import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class JobSeekerCongratulationsPage extends StatelessWidget {
  const JobSeekerCongratulationsPage({super.key});

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('It only takes 3-5 minutes and you can edit it later. We\'ll save as you go.',
                          style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                        ),
                         SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            //onpressed

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0038FF),
                            padding: EdgeInsets.all(20),
                          ),
                          child: const Text('Get Started',
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
                    
                    // SizedBox(
                    //   width: 430,
                    //   child: BlueOutlinedBoxButton(
                    //     onPressed: () {},
                    //     text: 'Continue',
                    //   ),
                    // ),
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