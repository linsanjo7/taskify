import 'package:flutter/material.dart';

class TaskDetailInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool autofocus;

  const TaskDetailInputField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha((255 * 0.5).toInt()),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.onSurfaceVariant.withAlpha((255 * 0.03).toInt()),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
