import 'package:flutter/material.dart';

/// A standardised text input field used throughout the app.
///
/// Wraps [TextFormField] with consistent decoration so every input
/// in the project looks and behaves the same way.
///
/// - [label] is displayed as a floating label above the field.
/// - [hint] is the placeholder shown inside the field when it is empty.
/// - [validator] hooks into a [Form] for inline validation.
/// - [prefixIcon] / [suffixIcon] attach icons at the leading / trailing edge.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      readOnly: readOnly,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
    );
  }
}
