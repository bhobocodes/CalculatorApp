import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final Function()? onTap;
  final String? Function(String?)? validator;

  const CalculatorTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,


      enableSuggestions: false,
      autocorrect: false,
      autofillHints: const [],

      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],

      onTap: onTap,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}