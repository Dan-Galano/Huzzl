import 'package:flutter/material.dart';

class IconButtonback extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider iconImage;

  IconButtonback({
    required this.onPressed,
    required this.iconImage,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(12.0),
        elevation: 0,
        minimumSize: Size(48, 48), 
      ),
      child: Image(
        image: iconImage,
        width: 20.0,
        height: 20.0,
      ),
    );
  }
}
