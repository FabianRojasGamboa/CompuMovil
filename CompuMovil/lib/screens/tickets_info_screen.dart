import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/objets/tickets.dart';
import 'package:proyecto/services/info_tickets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/widgets/app_bar.dart';
import 'package:dio/dio.dart';

final Dio _client = Dio(BaseOptions(
  baseUrl: 'https://api.sebastian.cl/oirs-utem',
));

class TicketsInfoScreen extends StatefulWidget {
  final String ticketToken;

  const TicketsInfoScreen({super.key, required this.ticketToken});

  @override
  _TicketsInfoScreenState createState() => _TicketsInfoScreenState();
}

class _TicketsInfoScreenState extends State<TicketsInfoScreen> {
  Ticket? _ticket;
  bool _isLoading = true;

  // Mapa de traducción para los estados
  final Map<String, String> statusTranslations = {
    "ERROR": "Error",
    "RECEIVED": "Recibido",
    "UNDER_REVIEW": "En revisión",
    "IN_PROGRESS": "En progreso",
    "PENDING_INFORMATION": "Pendiente de información",
    "RESOLVED": "Resuelto",
    "CLOSED": "Cerrado",
    "REJECTED": "Rechazado",
    "CANCELLED": "Cancelado",
  };

  @override
  void initState() {
    super.initState();
    _saveTicketToken(); // Guarda el ticketToken en SharedPreferences
    _fetchTicketData(); // Obtiene la información del ticket
  }

  Future<void> _saveTicketToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ticketToken', widget.ticketToken);
  }

  Future<void> _fetchTicketData() async {
    final ticketService = TicketService();
    final ticket = await ticketService.fetchTicket();
    setState(() {
      _ticket = ticket;
      _isLoading = false;
    });
  }

  Future<void> _deleteTicket(String ticketToken) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket eliminado correctamente')),
        );
        Navigator.of(context).pop(); // Regresa a la pantalla anterior
      } else {
        print(
            "Error al eliminar el ticket. Código HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al intentar eliminar el ticket: $e");
    }
  }

  Future<void> _confirmDeleteTicket() async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este ticket?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela la eliminación
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma la eliminación
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _deleteTicket(widget
          .ticketToken); // Llama a la función de eliminación si el usuario confirma
    }
  }

  @override
  Widget build(BuildContext context) {
    // Traducir el estado usando el mapa
    String translatedStatus =
        statusTranslations[_ticket?.status] ?? _ticket?.status ?? '';

    return Scaffold(
      appBar: const BarraApp(titulo: "Ticket", showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _ticket == null
                ? const Center(
                    child: Text("No se encontró información del ticket."),
                  )
                : Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Información del ticket",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Tipo: ${_ticket!.type}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Asunto: ${_ticket!.subject}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Mensaje: ${_ticket!.message}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Categoría: ${_ticket!.category.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Estado: $translatedStatus", // Estado traducido
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Creado el: ${DateFormat('yyyy-MM-dd HH:mm').format(_ticket!.created)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Última actualización: ${DateFormat('yyyy-MM-dd HH:mm').format(_ticket!.created)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              onPressed: _confirmDeleteTicket,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.purple,
                              ),
                              child: const Text('Eliminar Ticket'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
