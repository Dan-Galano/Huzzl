import 'package:flutter/material.dart';

class LightBlueHinttext extends StatelessWidget {
  final double? width;
  final TextEditingController controller;
  final String hintText;

  LightBlueHinttext({
    this.width,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
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
