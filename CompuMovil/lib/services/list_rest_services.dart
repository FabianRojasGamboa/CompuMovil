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

// Función para cargar tipos desde SharedPreferences
Future<List<String>?> loadTypesFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('types');
}

// Función para cargar estados desde SharedPreferences
Future<List<String>?> loadStatusesFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('statuses');
}

// Función optimizada para obtener todos los tickets
Future<List<Ticket>> AllTickets() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String idToken = prefs.getString('idToken') ?? '';
  List<Categories> categories = await loadCategories();
  List<String>? types = await loadTypesFromPrefs();
  List<String>? statuses = await loadStatusesFromPrefs();

  if (categories.isEmpty ||
      types == null ||
      statuses == null ||
      idToken.isEmpty) {
    _logger.e("Faltan datos en categorías, tipos, estados, o idToken.");
    return [];
  }

  List<Future<List<Ticket>>> requests = [];
  for (var category in categories) {
    for (var type in types) {
      for (var status in statuses) {
        requests.add(_fetchTickets(category.token, type, status, idToken));
      }
    }
  }

  try {
    List<List<Ticket>> results = await Future.wait(requests);
    return results.expand((tickets) => tickets).toList();
  } catch (e) {
    _logger.e("Error al obtener tickets: $e");
    return [];
  }
}

// Función auxiliar para realizar solicitudes de tickets
Future<List<Ticket>> _fetchTickets(
    String categoryToken, String type, String status, String idToken) async {
  try {
    Response<String> response = await _client.get(
      '/v1/icso/$categoryToken/tickets',
      queryParameters: {
        'categoryToken': categoryToken,
        'type': type,
        'status': status
      },
      options: Options(
        headers: {'Authorization': 'Bearer $idToken'},
        validateStatus: (status) => status! < 500,
      ),
    );

    final int httpCode = response.statusCode ?? 400;
    if (httpCode == 404) {
      _logger.e(
          "Endpoint no encontrado para categoryToken: $categoryToken, type: $type, status: $status");
      return [];
    } else if (httpCode >= 200 && httpCode < 300) {
      final String data = response.data ?? '';
      return List<Ticket>.from(
          json.decode(data).map((x) => Ticket.fromJson(x)));
    } else {
      _logger.e(
          "Error en la solicitud para categoryToken: $categoryToken, type: $type, status: $status. Código HTTP: $httpCode");
      return [];
    }
  } catch (e) {
    _logger.e("Error en la solicitud: $e");
    return [];
  }
}
