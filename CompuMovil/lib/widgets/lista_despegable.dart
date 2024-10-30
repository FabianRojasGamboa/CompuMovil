import 'package:flutter/material.dart';

class ListaDesplegable extends StatefulWidget {
  final List<String> opciones;

  const ListaDesplegable({Key? key, required this.opciones}) : super(key: key);

  @override
  _ListaDesplegableState createState() => _ListaDesplegableState();
}

class _ListaDesplegableState extends State<ListaDesplegable> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    // Inicializar el valor seleccionado con el primer elemento de la lista pasada por parámetro
    dropdownValue = widget.opciones.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          "Categorías",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
            border: Border.all(
                color: Colors.grey, width: 2), // Color y grosor del borde
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              hint: const Text(
                "Seleccione una opción",
                style: TextStyle(fontSize: 14),
              ),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16), // Estilo del texto seleccionado
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.black), // Icono personalizado
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items:
                  widget.opciones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor:
                  Colors.white, // Color de fondo del menú desplegable
            ),
          ),
        ),
      ],
    );
  }
}
