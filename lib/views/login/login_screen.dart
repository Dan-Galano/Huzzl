import 'package:flutter/material.dart';
import 'package:huzzl_web/views/user%20option/user_option_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_hinttext.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onToggle;
  LoginScreen({super.key, required this.onToggle});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 670,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login your account',
            style: TextStyle(
              fontSize: 32,
              color: Color(0xff373030),
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff373030),
                fontFamily: 'Galano',
              ),
            ),
          ),
          const SizedBox(height: 8),
          LightBlueTextField(controller: emailController),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff373030),
                fontFamily: 'Galano',
              ),
            ),
          ),
          const SizedBox(height: 8),
          LightBlueHinttext(
            controller: passwordController,
            hintText: 'Password (8 or more characters)',
            obscureText: true,
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                //onpressed
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Galano',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onToggle,
                child: const Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              BlueFilledCircleButton(
                width: 150,
                onPressed: () {},
                text: 'Login',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
