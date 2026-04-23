import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.fieldController,
    required this.fieldIcon,
    required this.fieldLabel,
    required this.fieldObscure,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController fieldController;
  final String fieldLabel;
  final bool fieldObscure;
  final Icon fieldIcon;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      obscureText: fieldObscure,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: fieldLabel,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),

        prefixIcon: fieldIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
