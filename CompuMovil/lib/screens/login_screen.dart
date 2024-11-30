import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:proyecto/services/google_services.dart';
import 'package:proyecto/services/rest_services.dart';
import 'package:proyecto/widgets/Down_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            const SizedBox(height: 100),
            const Text(
              "Utem Oirs",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 50),
            ClipOval(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/utem.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              "Inicia sesión con tu cuenta UTEM a través de Google",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    GoogleService.logIn().then((result) async {
                      if (result) {
                        _logger.i("Me autentifiqué");

                        // Obtiene el token antes de llamar a la API
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('idToken') ?? '';

                        try {
                          await RestService.categories();
                          await RestService.fetchAndSaveTypes();
                          await RestService.fetchAndSaveStatuses();

                          // Navega a la pantalla DownMenu
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DownMenu()),
                          );
                        } catch (e) {
                          _logger.e("Error al consumir la API: $e");
                          await GoogleService.logOut();
                          // Muestra el cuadro de diálogo de error por conexión
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error de Conexión"),
                                content: const Text(
                                    "Por favor, comprueba tu conexión a internet."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el cuadro de diálogo
                                    },
                                    child: const Text("Aceptar"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        _logger.i("Error de autenticación");

                        // Muestra el cuadro de diálogo por error de autenticación
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error de Autenticación"),
                              content: const Text(
                                  "Por favor, comprueba tu conexión a internet."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el cuadro de diálogo
                                  },
                                  child: const Text("Aceptar"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/images/google.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const SizedBox(
                      width: 150,
                      height: 70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
