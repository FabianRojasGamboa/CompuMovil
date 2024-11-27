import 'package:flutter/material.dart';
import 'package:proyecto/services/delete_tickets.dart';
import 'package:proyecto/objets/tickets.dart';
import 'package:proyecto/services/list_rest_services.dart';
import 'tickets_info_screen.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    _ticketsFuture = allTickets();
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _loadTickets();
    });
    await _ticketsFuture;
  }

  void _deleteTicket(Ticket ticket) async {
    try {
      await deleteTicket(ticket.token);
      setState(() {
        _ticketsFuture = Future.value(_ticketsFuture
            .then((tickets) => tickets.where((t) => t != ticket).toList()));
      });
    } catch (e) {
      print("Error al eliminar el ticket: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el ticket')),
      );
    }
  }

  // Función para obtener el color de fondo según el tipo de ticket
  Color _getTicketColor(String ticketType) {
    switch (ticketType.toLowerCase()) {
      case 'claim':
        return Colors.redAccent.shade100;
      case 'suggestion':
        return Colors.greenAccent.shade100;
      case 'information':
        return Colors.blueAccent.shade100;
      default:
        return Colors.grey.shade200; // Color de fondo por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título antes de la lista
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Mis Tickets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Ticket>>(
            future: _ticketsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No se encontraron tickets.'));
              } else {
                final tickets = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: _refreshTickets,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketsInfoScreen(ticketToken: ticket.token),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: _getTicketColor(ticket.type), // Fondo
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 85, 85, 85), // Borde negro
                                  width: 1.5, // Grosor del borde
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.subject,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ticket.message,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
