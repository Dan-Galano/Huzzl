import 'package:flutter/material.dart';
import 'package:huzzl_web/views/login/login.dart';
import 'package:huzzl_web/views/recruiters/register/00%20registration_screen.dart';
import 'package:huzzl_web/views/user%20option/user_option.dart';

void main() {
  runApp(const HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      // home: UserOptionScreen(),
      home: RecruiterRegistrationScreen(),
    );
  }
}
