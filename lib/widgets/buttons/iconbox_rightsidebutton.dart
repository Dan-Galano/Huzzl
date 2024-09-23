import 'package:flutter/material.dart';

class IconBoxRightsideButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final ImageProvider iconImage;
  final double width;

  IconBoxRightsideButton({
    required this.onPressed,
    required this.text,
    required this.iconImage,
    this.width = double.infinity, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0038FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), 
        ),
        padding: EdgeInsets.all(12.0),
        fixedSize: Size(width, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, 
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8.0),
          Image(
            image: iconImage,
            width: 20.0,
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
