import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/services/rest_services.dart';

class TicketsViewList extends StatelessWidget {
  static final Logger _logger = Logger();

  const TicketsViewList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Lista'),
        Center(
          child: FloatingActionButton(
            onPressed: () {
              Future<void> future = RestService.list_tickets();
              future.whenComplete(() {
                _logger.d("termine");
              });
            },
            child: const Text('data'),
          ),
        ),
      ],
    );
  }
}
