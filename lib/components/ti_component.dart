import 'package:flutter/material.dart';

class TiComponent extends StatelessWidget {
  final bool isPassword;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validate;
  final void Function(String) change;

  const TiComponent({super.key, 
    this.isPassword = false,
    required this.label,
    this.hint = "",
    this.keyboardType = TextInputType.text,
    required this.validate,
    required this.change, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: validate,
      onChanged: change,
    );
  }
}
