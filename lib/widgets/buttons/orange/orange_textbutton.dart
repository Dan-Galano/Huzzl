import 'package:flutter/material.dart';

class OrangeTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;

  OrangeTextButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1.5),
        padding: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          color: Color(0xFFFD7206),
          fontFamily: 'Galano',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
