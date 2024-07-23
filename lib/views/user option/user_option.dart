import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/hoverable_option_card.dart';

class UserOptionScreen extends StatelessWidget {
  const UserOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Image.asset('assets/images/huzzl.png', width: 80),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join as a recruiter or job-seeker?',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HoverableOptionCard(
                        title: "I'm a recruiter, hiring for a project",
                        assetPath: 'assets/images/CV.png',
                        color: Color(0xff0038FF),
                        borderColor: Color(0xff0038FF),
                      ),
                      SizedBox(width: 20),
                      HoverableOptionCard(
                        title: "I'm a job-seeker, looking for work",
                        assetPath: 'assets/images/Hired.png',
                        color: Color(0xffFD7206),
                        borderColor: Color(0xffFD7206),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}