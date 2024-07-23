import 'package:flutter/material.dart';
import 'package:huzzl_web/views/user%20option/user_option.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned(
          //   top: 20,
          //   left: 20,
          //   child: Image.asset('assets/images/huzzl.png', width: 80),
          // ),
          const NavBarLoginRegister(),
          Center(
            child: Container(
              width: 670,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
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
                  TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
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
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      hintText: 'Password (8 or more characters)',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                        onPressed: () {
                          //onpressed
                        },
                        child: const Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            //onpressed
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserOptionScreen(),));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0038FF),
                            padding: EdgeInsets.all(20),
                          ),
                          child: const Text('LOGIN',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
