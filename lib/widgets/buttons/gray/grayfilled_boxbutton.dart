import 'package:flutter/material.dart';

class GrayFilledBoxButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width; 

  GrayFilledBoxButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF8E8E8E), 
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontFamily: 'Galano',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
