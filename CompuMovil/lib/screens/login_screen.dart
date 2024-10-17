import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/screens/error_screen.dart';
import 'package:proyecto/services/google_services.dart';
import 'package:proyecto/widgets/Down_menu.dart';
import 'package:proyecto/widgets/app_bar.dart';

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraApp(titulo: 'Pagina de Login'),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(100),
            child: ElevatedButton(
                onPressed: () {
                  GoogleService.logIn().then((result) {
                    if (result) {
                      _logger.i("Me autentifique");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DownMenu()));
                    } else {
                      _logger.i("fui bueno");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ErrorScreen();
                      }));
                    }
                  });
                },
                child: const Row(
                    children: [Icon(Icons.g_mobiledata), Text('Login')]))),
      ),
    );
  }
}
