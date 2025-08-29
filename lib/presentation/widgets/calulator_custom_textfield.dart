import 'package:flutter/material.dart';

class CalulatorCustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const CalulatorCustomTextfield({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 18),
      autofocus: true,
      maxLines: 4,
      minLines: 2,
      decoration: InputDecoration(
        hintText: r'Examples: 1,2,3  or  //;\n1;2  or  1\n2,3',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
