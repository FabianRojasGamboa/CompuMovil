import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/objets/categories.dart';
import 'package:proyecto/objets/tickets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _client = Dio(BaseOptions(
  baseUrl: 'https://api.sebastian.cl/oirs-utem',
  headers: {'accept': "application/json"},
));
final Logger _logger = Logger();

// Función para cargar categorías desde SharedPreferences
Future<List<Categories>> loadCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? categoriesData = prefs.getString('categories');
  if (categoriesData != null) {
    List<dynamic> jsonData = json.decode(categoriesData);
    return jsonData.map((json) => Categories.fromJson(json)).toList();
  }
  return [];
}

// Función para cargar tipos y estados desde SharedPreferences
Future<List<String>?> loadPrefsList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

// Función optimizada para obtener todos los tickets
Future<List<Ticket>> allTickets() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String idToken = prefs.getString('idToken') ?? '';
  List<Categories> categories = await loadCategories();
  List<String>? types = await loadPrefsList('types');
  List<String>? statuses = await loadPrefsList('statuses');

  if (categories.isEmpty ||
      types == null ||
      statuses == null ||
      idToken.isEmpty) {
    _logger.e("Faltan datos en categorías, tipos, estados, o idToken.");
    return [];
  }

  List<Future<List<Ticket>>> requests = categories.map((category) {
    return _fetchTickets(category.token, types, statuses, idToken);
  }).toList();

  try {
    List<List<Ticket>> results = await Future.wait(requests);
    return results.expand((tickets) => tickets).toList();
  } catch (e) {
    _logger.e("Error al obtener tickets: $e");
    return [];
  }
}

// Función auxiliar para realizar solicitudes de tickets
Future<List<Ticket>> _fetchTickets(String categoryToken, List<String> types,
    List<String> statuses, String idToken) async {
  try {
    // Enviar una solicitud que incluya todos los types y statuses para la categoría
    Response<String> response = await _client.get(
      '/v1/icso/$categoryToken/tickets',
      queryParameters: {
        'type': types.join(','), // Enviar todos los tipos en un solo parámetro
        'status':
            statuses.join(','), // Enviar todos los estados en un solo parámetro
      },
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
        validateStatus: (status) => status! < 500,
      ),
    );

    final int httpCode = response.statusCode ?? 400;
    if (httpCode == 404) {
      _logger.e("Endpoint no encontrado para categoryToken: $categoryToken");
      return [];
    } else if (httpCode >= 200 && httpCode < 300) {
      final String data = response.data ?? '';
      return List<Ticket>.from(
          json.decode(data).map((x) => Ticket.fromJson(x)));
    } else {
      _logger.e(
          "Error en la solicitud para categoryToken: $categoryToken. Código HTTP: $httpCode");
      return [];
    }
  } catch (e) {
    _logger.e("Error en la solicitud: $e");
    return [];
  }
}
