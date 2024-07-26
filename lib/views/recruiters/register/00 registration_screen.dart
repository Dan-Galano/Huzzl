import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/01%20company_profile.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterRegistrationScreen extends StatefulWidget {
  RecruiterRegistrationScreen({super.key});

  @override
  State<RecruiterRegistrationScreen> createState() =>
      _RecruiterRegistrationScreenState();
}

class _RecruiterRegistrationScreenState
    extends State<RecruiterRegistrationScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          NavBarLoginRegister(),
          CompanyProfileScreen(),
        ],
      ),
    );
  }
}
