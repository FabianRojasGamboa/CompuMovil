import 'package:flutter/material.dart';
import 'package:proyecto/widgets/app_bar.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BarraApp(titulo: 'Error'),
      body: Center(
        child: Column(
          children: [
            Icon(Icons.error, size: 100, color: Colors.red),
            Text('Ha ocurrido un problema y no se puede procesar su solicitud',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
