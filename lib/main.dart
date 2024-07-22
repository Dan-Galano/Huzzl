import 'package:flutter/material.dart';

void main() {
  runApp(const HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Column(),
      ),
    );
  }
}
