import 'package:flutter/material.dart';

class ReservedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Reserved',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}