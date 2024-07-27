import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/01%20company_profile.dart';
import 'package:huzzl_web/views/recruiters/register/03%20hiring_manager.dart';
import 'package:huzzl_web/views/recruiters/register/05%20details_hiring_manager.dart';
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
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
          Expanded(
            child:
                // CompanyProfileScreen(),
                // const HiringManagerProfileScreen(),
                AccountHiringManagerScreen(),
          )
        ],
      ),
    );
  }
}
