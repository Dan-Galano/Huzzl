import 'package:flutter/material.dart';
import 'package:huzzl_web/views/homepage.dart';

void main() {
  runApp(const HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
