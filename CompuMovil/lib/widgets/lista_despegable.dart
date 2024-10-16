import 'package:flutter/material.dart';

class ListaDesplegable extends StatefulWidget {
  const ListaDesplegable({super.key});

  @override
  _ListaDesplegableState createState() => _ListaDesplegableState();
}

class _ListaDesplegableState extends State<ListaDesplegable> {
  static const List<String> list = <String>[
    'Activos',
    'Resueltos',
    'Rechazados'
  ];

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
