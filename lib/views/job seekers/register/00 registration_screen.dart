import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/register/01%20jobseeker_profile.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class JobSeekerRegistrationScreen extends StatefulWidget {
  const JobSeekerRegistrationScreen({super.key});

  @override
  State<JobSeekerRegistrationScreen> createState() => _JobSeekerRegistrationScreenState();
}

class _JobSeekerRegistrationScreenState extends State<JobSeekerRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBarLoginRegister(),
          JobSeekerProfileScreen(),
        ],
      ),
    );
  }
}