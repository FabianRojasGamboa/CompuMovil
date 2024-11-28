import 'package:flutter/material.dart';
import 'package:proyecto/screens/login_screen.dart';
import 'package:proyecto/services/google_services.dart';

class BarraApp extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool showLeading;

  const BarraApp({
    super.key,
    required this.titulo,
    this.showLeading = false, // Valor predeterminado en false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          showLeading, // Controla automáticamente el botón de retroceso
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
      backgroundColor: Colors.purple[100],
      title: Text(titulo),
      centerTitle: true,
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 75, 75, 75).withOpacity(0.9),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
            size: 30,
            semanticLabel: "Cerrar Sesión", // Tamaño del ícono ajustado
          ),
          onPressed: () async {
            bool? confirmLogout = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    '¿Estás seguro de que deseas cerrar sesión?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );

            if (confirmLogout == true) {
              await GoogleService.logOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
          tooltip: 'Cerrar sesión',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
