import 'package:flutter/material.dart';

class Buttom extends StatelessWidget {
  const Buttom({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const SizedBox(
        width: 150,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.abc),
              Text('Crear tickets'),
            ],
          ),
        ),
      ),
    );
  }
}
