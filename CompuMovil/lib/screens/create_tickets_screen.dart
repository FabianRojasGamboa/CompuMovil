import 'package:flutter/material.dart';
import 'package:proyecto/services/create_tickets_form.dart';

class CreateTicketsScreen extends StatelessWidget {
  const CreateTicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CreateTickets(),
    );
  }
}
