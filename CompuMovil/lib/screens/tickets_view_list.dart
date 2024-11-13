import 'package:flutter/material.dart';
import 'package:proyecto/services/delete_tickets.dart';
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
    _loadTickets();
  }

  void _loadTickets() {
    _ticketsFuture =
        AllTickets(); // Llama a la función para obtener los tickets
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _loadTickets(); // Recarga los tickets
    });
    await _ticketsFuture; // Espera a que se recarguen antes de terminar el refresco
  }

  void _deleteTicket(Ticket ticket) async {
    try {
      await deleteTicket(ticket.token);
      setState(() {
        // Elimina el ticket de la lista actual
        _ticketsFuture = Future.value(_ticketsFuture
            .then((tickets) => tickets.where((t) => t != ticket).toList()));
      });
    } catch (e) {
      print("Error al eliminar el ticket: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el ticket')),
      );
    }
  }

  void _confirmDeleteTicket(Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content:
              const Text("¿Estás seguro de que deseas eliminar este ticket?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                _deleteTicket(ticket); // Llama a la función de eliminación
              },
              child: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
          return RefreshIndicator(
            onRefresh: _refreshTickets, // Añade la funcionalidad de refrescar
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                          'Categoria: ${ticket.category.name}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 2),
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
                                Text(
                                  'Tipo: ${ticket.type}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Mensaje: ${ticket.message}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Actualizar",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () =>
                                          _confirmDeleteTicket(ticket),
                                      child: const Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
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
            ),
          );
        }
      },
    );
  }
}
