import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/01%20location.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CongratulationPage(),
//     );
//   }
// }

class CongratulationPage extends StatelessWidget {
  const CongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           NavBarLoginRegister(),
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
                      'Congratulations! Your account has been created.',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Answer a few questions and start building your profile',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),
                    const Text(
                      'It only takes 3-5 minutes and you can edit it later. We’ll save as you go.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 430,
                      child: BlueOutlinedBoxButton(
                        onPressed: () {
                          // Navigator.of(context)
                          //     .pushReplacement(MaterialPageRoute(
                          //   builder: (context) => LocationSelectorPage(),
                          // ));
                        },
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
