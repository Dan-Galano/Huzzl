import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      color: Colors.grey[900],
      padding: EdgeInsets.all(20), 
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Educational purposes only. Copyright © 2024 Huzzl Inc. Capstone Project 2 - PSU Urdaneta',
            style: TextStyle(
                color: Colors.white70, fontFamily: 'Galano', fontSize: 14),
          ),
        ],
      ),
    );
  }
}
