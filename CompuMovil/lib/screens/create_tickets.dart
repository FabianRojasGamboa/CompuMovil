import 'package:flutter/material.dart';
import 'package:proyecto/objets/categories.dart';
import 'package:proyecto/services/rest_services.dart';
import 'package:proyecto/widgets/buttom.dart';
import 'package:proyecto/widgets/form_UI.dart';
import 'package:proyecto/widgets/lista_despegable.dart';

class CreateTickets extends StatefulWidget {
  const CreateTickets({Key? key}) : super(key: key);

  @override
  _CreateTicketsState createState() => _CreateTicketsState();
}

class _CreateTicketsState extends State<CreateTickets> {
  late Future<List<String>> _categoryNamesFuture;
  final TextEditingController _sujetoController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar los nombres de las categorías al iniciar el widget
    _categoryNamesFuture = loadCategoryNames();
  }

  // Método para cargar solo los nombres de las categorías
  Future<List<String>> loadCategoryNames() async {
    List<Categories> categoriesList = await RestService.loadCategories();
    // Extraer solo los nombres de las categorías
    return categoriesList.map((category) => category.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categoryNamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error al cargar categorías: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No hay categorías disponibles");
        } else {
          // Pasar los nombres de las categorías al widget ListaDesplegable
          List<String> categoryNames = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ListaDesplegable(opciones: categoryNames),
                ),
                const SizedBox(height: 20),
                // Campo de texto para "Sujeto"
                FormUI(_sujetoController, "Sujeto", 70),
                const SizedBox(height: 20),

                // Campo de texto para "Mensaje"
                FormUI(_mensajeController, "Mensaje", 220),

                const Center(
                  child: Text(
                      "Sube un archivo complementario MAx 5MB.\n Tipos permitidos: JPEG, PNG, TXT, PDF "),
                ),
                const SizedBox(height: 50),
                const Center(
                  child: CustomButton(
                    text: 'Crear Tickets',
                    icon: Icons.add, // Cambia el icono aquí
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
