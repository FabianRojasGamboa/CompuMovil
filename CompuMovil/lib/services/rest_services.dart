import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/objets/list_tickets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestServices {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();

  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';

  // Atributo para almacenar los tickets
  static List<ListTickets> _tickets = [];

  static Future<List<ListTickets>> getTickets() async {
    // Interceptor para mostrar los logs de las solicitudes/respuestas
    _client.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));

    // Obtener el token almacenado en SharedPreferences
    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';

    if (idToken.isNotEmpty) {
      const String url = "$_baseUrl/v1/info/tickets";
      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken',
      };

      try {
        // Realizar la solicitud GET
        Response<String> response = await _client.get(
          url,
          options: Options(headers: headers),
        );

        // Verificar el código de respuesta
        final int httpCode = response.statusCode ?? 400;
        if (httpCode >= 200 && httpCode < 300) {
          // Procesar la respuesta JSON
          final String responseBody = response.data ?? '';
          List<dynamic> jsonResponse = json.decode(responseBody);

          // Convertir la respuesta a una lista de instancias de ListTickets
          _tickets =
              jsonResponse.map((json) => ListTickets.fromJson(json)).toList();

          return _tickets; // Devolver la lista de tickets
          print(_tickets);
        } else {
          // Manejar errores si el código no es exitoso
          _logger.e("Error en la respuesta: $httpCode");
          return []; // Devolver una lista vacía en caso de error
        }
      } catch (e) {
        // Capturar y loggear cualquier excepción
        _logger.e("Error al realizar la solicitud: $e");
        return []; // Devolver una lista vacía en caso de error
      }
    } else {
      _logger.e("Token no disponible o vacío.");
      return []; // Devolver una lista vacía si no hay token
    }
  }

  // Método para obtener los tickets almacenados
  static List<ListTickets> getStoredTickets() {
    return _tickets; // Devolver la lista de tickets almacenados
  }
}
