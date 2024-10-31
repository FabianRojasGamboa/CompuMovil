import 'package:flutter/material.dart';
import 'package:proyecto/objets/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  // Función para cargar categorías desde SharedPreferences
  Future<List<Categories>> loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonCategories = prefs.getString('categories');

    if (jsonCategories != null) {
      List<dynamic> decodedData = json.decode(jsonCategories);
      return List<Categories>.from(
          decodedData.map((x) => Categories.fromJson(x)));
    } else {
      return [];
    }
  }

  // Función para cargar tipos desde SharedPreferences
  Future<List<String>?> loadTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('types');
  }

  // Función para cargar estados desde SharedPreferences
  Future<List<String>?> loadStatuses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('statuses');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([loadCategories(), loadTypes(), loadStatuses()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar datos'));
          } else {
            List<Categories> categories = snapshot.data![0];
            List<String>? types = snapshot.data![1];
            List<String>? statuses = snapshot.data![2];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aquí puedes agregar el contenido que desees antes de la lista
                  Text(
                    'Lista de Tickets',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                      height: 16), // Espacio entre el título y la lista

                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final type = types != null && types.isNotEmpty
                            ? types[index % types.length]
                            : 'Sin tipo';
                        final status = statuses != null && statuses.isNotEmpty
                            ? statuses[index % statuses.length]
                            : 'Sin estado';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 8, // Ajusta la altura de la sombra aquí
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                            title: Text(category.name),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipo: $type',
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Text('Estado: $status',
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('Descripción: ${category.description}',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
