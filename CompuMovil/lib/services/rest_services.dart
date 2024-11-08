import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/objets/categories.dart';

class RestService {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();
  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';

  // Método para consumir el endpoint de categorías
  static Future<void> categories() async {
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
      const String url = "$_baseUrl/v1/info/categories";

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken'
      };
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode >= 200 && httpCode < 300) {
        final String salida = response.data ?? '';
        List<Categories> list = List<Categories>.from(
            json.decode(salida).map((x) => Categories.fromJson(x)));

        // Guardar la lista de categorías en SharedPreferences
        await saveCategories(list);
        _logger.i(salida);
      }
    }
  }

  // Método para guardar la lista de categorías en SharedPreferences
  static Future<void> saveCategories(List<Categories> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCategories =
        json.encode(List<dynamic>.from(categories.map((x) => x.toJson())));
    await prefs.setString('categories', jsonCategories);
  }

  // Método para recuperar la lista de categorías desde SharedPreferences
  static Future<List<Categories>> loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonCategories = prefs.getString('categories');

    if (jsonCategories != null) {
      List<dynamic> decodedData = json.decode(jsonCategories);
      return List<Categories>.from(
          decodedData.map((x) => Categories.fromJson(x)));
    } else {
      return [];
    }
  }

  // Método para consumir el endpoint de tipos
  static Future<void> fetchAndSaveTypes() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';

    if (idToken.isNotEmpty) {
      const String url = "$_baseUrl/v1/info/types";

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken'
      };
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode >= 200 && httpCode < 300) {
        final List<dynamic> types = json.decode(response.data ?? '');
        _logger.i("Tipos recibidos: $types");

        // Guardar los tipos en SharedPreferences
        await saveTypes(types.cast<String>());
      } else {
        _logger.e("Error al obtener tipos: ${response.statusCode}");
      }
    } else {
      _logger.e("No se encontró idToken");
    }
  }

  // Método para guardar los tipos en SharedPreferences
  static Future<void> saveTypes(List<String> types) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('types', types);
    _logger.i("Tipos guardados en SharedPreferences: $types");
  }

  // Método para cargar los tipos desde SharedPreferences
  static Future<List<String>?> loadTypesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('types');
  }

  // Método para consumir el endpoint de estados
  static Future<void> fetchAndSaveStatuses() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';

    if (idToken.isNotEmpty) {
      const String url =
          "$_baseUrl/v1/info/status"; // Cambia la URL a /v1/info/status

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken'
      };
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode >= 200 && httpCode < 300) {
        final List<dynamic> statuses =
            json.decode(response.data ?? ''); // Cambia el nombre a statuses
        _logger.i("Estados recibidos: $statuses");

        // Guardar los estados en SharedPreferences
        await saveStatuses(statuses.cast<String>());
      } else {
        _logger.e("Error al obtener estados: ${response.statusCode}");
      }
    } else {
      _logger.e("No se encontró idToken");
    }
  }

  // Método para guardar los estados en SharedPreferences
  static Future<void> saveStatuses(List<String> statuses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'statuses', statuses); // Guarda con clave 'statuses'
    _logger.i("Estados guardados en SharedPreferences: $statuses");
  }
}
