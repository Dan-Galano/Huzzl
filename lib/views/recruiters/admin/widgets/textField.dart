import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextFieldConstant extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  bool isEmail;
  TextFieldConstant({
    required this.controller,
    required this.hintText,
    this.isEmail = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1E1FF),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1E1FF),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1E1FF),
            width: 1.5,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required field.';
        }

        if (isEmail) {
          if (!EmailValidator.validate(value)) {
            return "Provide a valid email address";
          }
        }
        return null;
      },
    );
  }
}
