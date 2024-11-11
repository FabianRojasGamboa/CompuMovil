import 'package:flutter/material.dart';

class ListaDesplegable extends StatefulWidget {
  final List<String> opciones;
  final ValueChanged<String> onChanged;

  const ListaDesplegable(
      {Key? key, required this.opciones, required this.onChanged})
      : super(key: key);

  @override
  _ListaDesplegableState createState() => _ListaDesplegableState();
}

class _ListaDesplegableState extends State<ListaDesplegable> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.opciones.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 335,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
                widget.onChanged(newValue!);
              },
              items:
                  widget.opciones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
