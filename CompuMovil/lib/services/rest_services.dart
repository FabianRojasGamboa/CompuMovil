import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/objets/access.dart';
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

        await saveCategories(list);
        _logger.i(salida);
      }
    }
  }

  static Future<void> saveCategories(List<Categories> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCategories =
        json.encode(List<dynamic>.from(categories.map((x) => x.toJson())));
    await prefs.setString('categories', jsonCategories);
  }

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

  // Método para consumir el endpoint de types
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

        await saveTypes(types.cast<String>());
      } else {
        _logger.e("Error al obtener tipos: ${response.statusCode}");
      }
    } else {
      _logger.e("No se encontró idToken");
    }
  }

  static Future<void> saveTypes(List<String> types) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('types', types);
    _logger.i("Tipos guardados en SharedPreferences: $types");
  }

  static Future<List<String>?> loadTypesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('types');
  }

  // Método para consumir el endpoint de status
  static Future<void> fetchAndSaveStatuses() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    final String idToken = instance.getString('idToken') ?? '';

    if (idToken.isNotEmpty) {
      const String url = "$_baseUrl/v1/info/status";

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken'
      };
      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode >= 200 && httpCode < 300) {
        final List<dynamic> statuses = json.decode(response.data ?? '');
        _logger.i("Estados recibidos: $statuses");

        await saveStatuses(statuses.cast<String>());
      } else {
        _logger.e("Error al obtener estados: ${response.statusCode}");
      }
    } else {
      _logger.e("No se encontró idToken");
    }
  }

  static Future<void> saveStatuses(List<String> statuses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('statuses', statuses);
    _logger.i("Estados guardados en SharedPreferences: $statuses");
  }

  // Método para consumir el endpoint de access
  static Future<void> access() async {
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
      const String url =
          "$_baseUrl/v1/info/access"; // Asegúrate de que este sea el endpoint correcto para access

      Map<String, String> headers = {
        'accept': _mime,
        'Authorization': 'Bearer $idToken'
      };

      Response<String> response =
          await _client.get(url, options: Options(headers: headers));
      final int httpCode = response.statusCode ?? 400;

      if (httpCode >= 200 && httpCode < 300) {
        final String salida = response.data ?? '';
        List<Access> list = List<Access>.from(json
            .decode(salida)
            .map((x) => Access.fromJson(x))); // Cambié Categories por Access

        await saveAccess(list); // Asegúrate de que tengas la función saveAccess
        _logger.i(salida);
      }
    }
  }

  // Método para guardar los datos de access en SharedPreferences
  static Future<void> saveAccess(List<Access> accessList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convertir la lista de objetos Access a JSON
    String jsonAccess =
        json.encode(List<dynamic>.from(accessList.map((x) => x.toJson())));

    // Guardar el JSON en SharedPreferences
    await prefs.setString('access', jsonAccess);
    _logger.i("Access guardado en SharedPreferences: $jsonAccess");
  }
}
