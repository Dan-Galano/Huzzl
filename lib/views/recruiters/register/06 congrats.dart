import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CongratulationPage(),
    );
  }
}

class CongratulationPage extends StatelessWidget {
  const CongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
          Padding(
            padding: const EdgeInsets.only(top: 150.0), 
            child: Center(  
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/congratulations.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Congratulations! Your account is created.',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Post a job, manage and find new recruits!',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 430,
                      child: BlueOutlinedBoxButton(
                        onPressed: () {},
                        text: 'Continue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
