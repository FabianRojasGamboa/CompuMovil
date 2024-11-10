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
              height: 100,
            ),
            const Text(
              "Utem Oirs",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width:
                  210, // Tamaño del círculo blanco (un poco más grande que el contenedor de la imagen)
              height: 210,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Color del borde blanco
              ),
              child: ClipOval(
                child: Container(
                  width: 200,
                  height:
                      200, // Asegúrate de que el ancho y la altura sean iguales para un círculo perfecto
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/signoUtem.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              "Ingresar con la cuenta Utem",
              style: TextStyle(fontSize: 15),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                                  builder: (context) => const ErrorScreen()));
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
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.zero, // Elimina el padding interno del botón
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/images/google.png'), // Ruta de la imagen
                          fit: BoxFit
                              .cover, // Hace que la imagen cubra todo el botón
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Container(
                      width: 150, // Ajusta el ancho del botón
                      height: 70, // Ajusta la altura del botón
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
