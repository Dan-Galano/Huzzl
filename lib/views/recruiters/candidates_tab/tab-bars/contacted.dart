import 'package:flutter/material.dart';

class ContactedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Contacted',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}