import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestService {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();

  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';

  // Método que acepta un token para el ticket
  static Future<void> list_tickets() async {
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
      String ticketToken = idToken; // Reemplaza con tu token real
      String url = "$_baseUrl/v1/icso/$ticketToken/ticket";

      _logger.i("URL de la solicitud: $url"); // Registra la URL

      Map<String, String> headers = {'accept': _mime, 'Authorization': idToken};
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode == 404) {
        _logger.e("Recurso no encontrado: $url");
      } else if (httpCode >= 200 && httpCode < 300) {
        final String salida = response.data ?? '';
        _logger.i(salida);
      } else {
        _logger.e("Error inesperado: $httpCode");
      }
    } else {
      _logger.e("El token de autorización está vacío.");
    }
  }
}
