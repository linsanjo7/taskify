import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final int? maxLines;
  final String? Function(String?)? validator;

  const TaskInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: validator,
    );
  }
}
