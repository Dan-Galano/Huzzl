import 'package:flutter/material.dart';

class BlueOutlinedBoxButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;

  BlueOutlinedBoxButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF0038FF), width: 1.5),
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          color: Color(0xFF0038FF),
          fontFamily: 'Galano',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
