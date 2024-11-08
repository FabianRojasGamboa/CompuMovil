import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Parámetro para el texto del botón
  final IconData icon; // Parámetro para el icono del botón
  final VoidCallback onPressed; // Parámetro para la acción del botón

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Usa el parámetro onPressed
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon), // Usa el parámetro icon
              const SizedBox(width: 8), // Espacio entre el icono y el texto
              Text(text), // Usa el parámetro text
            ],
          ),
        ),
      ),
    );
  }
}
