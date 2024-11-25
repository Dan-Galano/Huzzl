import 'package:flutter/material.dart';
import 'package:huzzl_web/video%20call/home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Video Calling App",
      home: HomeScreen(),
    );
  }
}
