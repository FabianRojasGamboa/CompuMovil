import 'package:flutter/material.dart';

class BarraApp extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const BarraApp({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: Colors.cyan,
      title: Text(titulo),
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
