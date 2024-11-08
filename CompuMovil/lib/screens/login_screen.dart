import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/screens/error_screen.dart';
import 'package:proyecto/services/google_services.dart';
import 'package:proyecto/services/rest_services.dart';
import 'package:proyecto/widgets/Down_menu.dart';

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            Container(
              width: 150,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/images/signoUtem.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: ElevatedButton(
                      onPressed: () {
                        GoogleService.logIn().then((result) async {
                          if (result) {
                            _logger.i("Me autentifique");

                            // Llama al servicio después de autenticar
                            try {
                              await RestService.categories();
                              await RestService.fetchAndSaveTypes();
                              await RestService.fetchAndSaveStatuses();

                              // Redirige al DownMenu después de guardar los datos
                              Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DownMenu()));
                            } catch (e) {
                              _logger.e("Error al consumir la API: $e");
                              Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ErrorScreen()));
                            }
                          } else {
                            _logger.i("fui bueno");
                            // ignore: use_build_context_synchronously
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ErrorScreen();
                            }));
                          }
                        });
                      },
                      child: const Row(children: [
                        Icon(Icons.g_mobiledata),
                        Text('Login')
                      ]))),
            ),
          ],
        ),
      ),
    );
  }
}
