import 'package:flutter/material.dart';
import 'package:huzzl_web/views/login/login_screen.dart';
import 'package:huzzl_web/views/user%20option/user_option_screen.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool _showLoginScreen = true;

  void _toggleScreen() {
    setState(() {
      _showLoginScreen = !_showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const NavBarLoginRegister(),
            Expanded(
              child: _showLoginScreen
                  ? LoginScreen(
                      onToggle: _toggleScreen,
                    )
                  : UserOptionScreen(
                      onToggle: _toggleScreen,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
