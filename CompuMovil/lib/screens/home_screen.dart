import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/widgets/buttom.dart';
import 'package:proyecto/widgets/lista_despegable.dart';

class HomeScreen extends StatelessWidget {
  static final Logger _logger = Logger();
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [Text('estoy dentro'), ListaDesplegable(), Buttom()],
      ),
    );
  }
}
