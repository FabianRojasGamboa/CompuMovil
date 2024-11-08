import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/services/list_rest_services.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tickets'),
      ),
      body: FutureBuilder<void>(
        future: RestService
            .AllTickets(), // Llamamos a la función AllTickets estática de RestService
        builder: (context, snapshot) {
          // Verifica el estado de la llamada
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Muestra un indicador de carga mientras esperamos
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Muestra el error si ocurre
          } else {
            return const Center(
                child: Text(
                    'Tickets cargados correctamente')); // Mensaje si la carga fue exitosa
          }
        },
      ),
    );
  }
}
