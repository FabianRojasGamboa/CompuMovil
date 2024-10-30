import 'package:flutter/material.dart';

Widget FormUI(TextEditingController controller, String text, double height) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 30.0),
    height: height,
    child: TextFormField(
      controller: controller,
      maxLines: 5,
      minLines: 1,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    ),
  );
}
