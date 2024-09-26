import 'package:flutter/material.dart';

class LightBluePrefix extends StatelessWidget {
  final double? width;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? prefixText; // Keep this as an optional parameter

  LightBluePrefix({
    this.width,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixText, // Initialize prefixText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 15,
        ),
        controller: controller,
        cursorColor: Color.fromARGB(255, 58, 63, 76),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 14.0,
          ),
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF8E8E8E),
          ),
          prefixIcon: Padding( // Use prefixIcon to make the symbol stay
            padding: const EdgeInsets.only(left: 10.0, right: 5.0),
            child: Text(
              prefixText ?? '₱ ', // Display the peso symbol
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 13,
                color: Colors.black, // Customize the style of the prefix symbol
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints( // Make sure the prefix fits well
            minWidth: 0,
            minHeight: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFFD1E1FF),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFFD1E1FF),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFFD1E1FF),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
