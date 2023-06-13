import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.label,
    required this.controler,
    required this.onFieldSubmit,
    required this.focusNode,
    required this.textInputType,
    required this.fieldValidator,
    this.isPass = false,
  });
  final FocusNode focusNode;
  final TextEditingController controler;
  final String? label;
  final TextInputType textInputType;
  final FormFieldSetter onFieldSubmit;
  final FormFieldValidator fieldValidator;
  final bool isPass;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      focusNode: focusNode,
      keyboardType: textInputType,
      obscureText: isPass,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(
          label.toString(),
        ),
        hintText: label,
      ),
      onFieldSubmitted: onFieldSubmit,
      validator: fieldValidator,
    );
  }
}
