import 'package:flutter/material.dart';

class LightBlueTextField extends StatelessWidget {
  final double? width;
  final TextEditingController controller;

  LightBlueTextField({this.width, required this.controller});

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      color: Color(0xFFD1E1FF),
      width: 1.5,
    );

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: borderSide,
          ),
        ),
      ),
    );
  }
}
