import 'package:dio/dio.dart';
import 'package:proyecto/objets/tickets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.sebastian.cl/oirs-utem/";

  Future<Ticket?> fetchTicket() async {
    try {
      // Obtiene el token de autorización y el ticketToken de SharedPreferences
      SharedPreferences instance = await SharedPreferences.getInstance();
      final String authorizationToken = instance.getString('idToken') ?? '';
      final String ticketToken = instance.getString('ticketToken') ?? '';

      // Configura los encabezados de la solicitud
      final headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      // Construye la URL con el ticketToken
      final url = '$_baseUrl/v1/icso/$ticketToken/ticket';

      // Realiza la solicitud GET
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      // Verifica si la solicitud fue exitosa
      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en una instancia de Ticket
        return Ticket.fromJson(response.data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching ticket: $e');
      return null;
    }
  }
}
