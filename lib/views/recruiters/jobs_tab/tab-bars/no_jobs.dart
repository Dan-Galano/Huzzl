import 'package:flutter/material.dart';

class NoJobPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'You don\'t have any job posts.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}
