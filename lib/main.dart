import 'package:flutter/material.dart';
import 'package:huzzl_web/views/login/login_screen.dart';
import 'package:huzzl_web/views/user%20option/login_register.dart';
import 'package:huzzl_web/views/user%20option/user_option_screen.dart';

void main() {
  runApp(const HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegister(),
      // home: UserOptionScreen(),
    );
  }
}
