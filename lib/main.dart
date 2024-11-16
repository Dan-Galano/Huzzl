import 'package:flutter/material.dart';
import 'package:huzzl_web/Landing_Page/landing_page.dart';
import 'package:huzzl_web/landing%20page/landing_page.dart';
import 'package:huzzl_web/views/login/login_register.dart';

void main() {
  runApp(HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LandingPage(), 
      home: LandingPageNew(),
    );
  }
}
