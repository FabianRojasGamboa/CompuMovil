import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _client = Dio(BaseOptions(
  baseUrl: 'https://api.sebastian.cl/oirs-utem',
));

Future<void> deleteTicket(String ticketToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String idToken = prefs.getString('idToken') ?? '';

  if (idToken.isEmpty) {
    throw Exception("Token de autenticación no encontrado.");
  }

  try {
    final response = await _client.delete(
      '/v1/icso/$ticketToken/ticket',
      options: Options(
        headers: {
          'Authorization': 'Bearer $idToken',
          'accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Ticket eliminado exitosamente.");
    } else {
      print("Error al eliminar el ticket. Código HTTP: ${response.statusCode}");
    }
  } catch (e) {
    print("Error al intentar eliminar el ticket: $e");
  }
}
