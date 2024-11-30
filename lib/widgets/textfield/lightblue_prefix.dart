import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightBluePrefix extends StatelessWidget {
  final double? width;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? prefixText;

  LightBluePrefix({
    this.width,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        obscureText: obscureText,
        style: TextStyle(fontSize: 15),
        controller: controller,
        cursorColor: Color.fromARGB(255, 58, 63, 76),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number, // Ensures only numeric input
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Only digits are allowed
        ],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF8E8E8E)),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 5.0),
            child: Text(
              prefixText ?? '₱ ',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
          ),
        ),
      ),
    );
  }
}