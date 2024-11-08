import 'package:flutter/material.dart';
import 'package:proyecto/services/list_rest_services.dart';
import 'package:proyecto/objets/tickets.dart';

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
    _ticketsFuture =
        AllTickets(); // Llama a la función para obtener los tickets
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ticket>>(
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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // Redondea los bordes
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      title: Text(
                        ticket.subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Tipo: ${ticket.category.name}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Status: ${ticket.status}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Categoría: ${ticket.type}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Mensaje: ${ticket.message}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
