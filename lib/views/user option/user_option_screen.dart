import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/hoverable_option_card.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class UserOptionScreen extends StatelessWidget {
  final VoidCallback onToggle;
  const UserOptionScreen({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButtonback(
                onPressed: onToggle,
                iconImage: const AssetImage('assets/images/backbutton.png'),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Join as a recruiter or job-seeker?',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HoverableOptionCard(
                title: "I'm a recruiter, hiring for a project",
                userType: 'recruiter',
                assetPath: 'assets/images/CV.png',
                color: Color(0xff0038FF),
                borderColor: Color(0xff0038FF),
              ),
              SizedBox(width: 20),
              HoverableOptionCard(
                title: "I'm a job-seeker, looking for work",
                userType: 'job-seeker',
                assetPath: 'assets/images/Hired.png',
                color: Color(0xffFD7206),
                borderColor: Color(0xffFD7206),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
