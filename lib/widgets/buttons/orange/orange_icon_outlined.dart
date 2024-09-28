import 'package:flutter/material.dart';

class OrangeIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width; 
  final String imagePath;

  OrangeIconButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity, 
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFFD7206), width: 1.5),
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 20, 
              height: 20, 
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFFFD7206),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
