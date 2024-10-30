import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListRestServices {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();

  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';

  // Método que acepta parámetros y obtiene los tickets
  static Future<void> fetchTickets(
      String categoryToken, String type, String status) async {
    _client.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));

    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';

    if (idToken.isNotEmpty) {
      final String url = '$_baseUrl/v1/icso/$categoryToken/tickets';

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': idToken,
      };

      Map<String, dynamic> queryParams = {
        'type': type,
        'status': status,
      };

      try {
        // Realiza la petición y obtiene la respuesta
        Response<String> response = await _client.get(
          url,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );

        final int httpCode = response.statusCode ?? 400;

        if (httpCode >= 200 && httpCode < 300) {
          final String responseBody = response.data ?? '';

          // Imprimir el JSON de la respuesta
          _logger.i('JSON de respuesta: $responseBody');

          // Aquí puedes almacenar el JSON en el sharedPreferences o procesarlo más tarde
          // Ejemplo: guardarlo en sharedPreferences para usar después si lo necesitas
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('ticketsJson', responseBody);
        } else {
          _logger.e('Error en la respuesta: $httpCode');
        }
      } catch (e) {
        _logger.e('Error al obtener los tickets: $e');
      }
    }
  }
}
