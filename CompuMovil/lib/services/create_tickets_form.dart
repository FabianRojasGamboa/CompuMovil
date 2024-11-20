import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/services/upload_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late Future<List<Categories>> _categoriesFuture;
  late Future<List<String>?> _typesFuture;
  final TextEditingController _sujetoController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();
  static const String _baseUrl = 'https://api.sebastian.cl/oirs-utem';
  Categories?
      _selectedCategory; // Variable para almacenar la categoría seleccionada
  String? _selectedType; // Variable para almacenar el tipo seleccionado
  final Dio _dio = Dio(); // Instancia de Dio para realizar la solicitud
  String? _ticketToken; // Variable de estado para almacenar el ticketToken
  bool _showUploadButton = false; // Control para mostrar botón de subida

  @override
  void initState() {
    super.initState();
    _categoriesFuture = RestService.loadCategories();
    _typesFuture = loadTypesFromPrefs();
  }

  Future<List<String>?> loadTypesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('types');
  }

  Future<void> _crearTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('idToken') ?? '';

    if (_selectedCategory == null ||
        _selectedType == null ||
        idToken.isEmpty ||
        _sujetoController.text.isEmpty ||
        _mensajeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Por favor, complete todos los campos e inicie sesión')),
      );
      return;
    }

    final url = '$_baseUrl/v1/icso/${_selectedCategory!.token}/ticket';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'type': _selectedType,
          'subject': _sujetoController.text,
          'message': _mensajeController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket creado exitosamente')),
        );

        final ticketData = response.data;
        if (ticketData != null && ticketData['token'] != null) {
          final ticketToken = ticketData['token'];
          await prefs.setString('ticketToken', ticketToken);
          print("Token del ticket guardado: $ticketToken");

          setState(() {
            _ticketToken = ticketToken;
          });

          _mostrarDialogoSubida(
              ticketToken); // Muestra el diálogo para subir archivo
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error al crear ticket: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      if (e is DioError && e.response != null) {
        print('Error: ${e.response!.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear ticket: ${e.response!.data}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear ticket: $e')),
        );
      }
    }
  }

  void _mostrarDialogoSubida(String ticketToken) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Desea subir un archivo?'),
        content: const Text(
            'Puede subir un archivo complementario (Máx. 5 MB) para este ticket.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _showUploadButton = false; // No mostrar el botón de subida
              });
              _limpiarCampos(); // Limpiar los campos solo si se niega subir el archivo
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _showUploadButton = true; // Mostrar el botón de subida
              });
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
  }

  void _limpiarCampos() {
    // Limpiar los campos solo si el usuario decide no subir el archivo
    setState(() {
      _sujetoController.clear();
      _mensajeController.clear();
      _selectedCategory = null;
      _selectedType = null;
      _ticketToken = null;
    });
  }

  Future<void> _subirArchivoExitosamente() async {
    // Lógica para subir el archivo exitosamente
    // Esto es un marcador de lugar y deberías reemplazarlo con tu código real de subida
    setState(() {
      _limpiarCampos(); // Limpiar campos después de subir el archivo exitosamente
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categories>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error al cargar categorías: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No hay categorías disponibles");
        } else {
          List<Categories> categories = snapshot.data!;
          return FutureBuilder<List<String>?>(
            future: _typesFuture,
            builder: (context, typesSnapshot) {
              if (typesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (typesSnapshot.hasError) {
                return Text("Error al cargar tipos: ${typesSnapshot.error}");
              } else if (!typesSnapshot.hasData ||
                  typesSnapshot.data!.isEmpty) {
                return const Text("No hay tipos disponibles");
              } else {
                List<String> types = typesSnapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Selecciona una categoría',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ListaDesplegable(
                          opciones: categories
                              .map((category) => category.name)
                              .toList(),
                          onChanged: (selectedName) {
                            setState(() {
                              _selectedCategory = categories.firstWhere(
                                  (category) => category.name == selectedName);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Selecciona un tipo',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ListaDesplegable(
                          opciones: types,
                          onChanged: (selectedType) {
                            setState(() {
                              _selectedType = selectedType;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormUI(_sujetoController, "Sujeto", 80),
                      const SizedBox(height: 10),
                      FormUI(_mensajeController, "Mensaje", 120),
                      const SizedBox(height: 10),
                      Center(
                        child: CustomButton(
                          text: 'Crear Tickets',
                          icon: Icons.add,
                          onPressed: _crearTicket,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_showUploadButton && _ticketToken != null)
                        Center(
                          child: UploadFile(
                            ticketToken: _ticketToken!,
                            onFileUploaded:
                                _subirArchivoExitosamente, // Callback después de subir el archivo
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
