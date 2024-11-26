import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/hoverable_option_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserOptionScreen extends StatelessWidget {
  final VoidCallback onToggle;
  const UserOptionScreen({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        var userOptionResponsiveness =
            sizingInformation.deviceScreenType == DeviceScreenType.mobile
                ? const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HoverableOptionCard(
                          title: "I'm a recruiter, hiring for a project",
                          userType: 'recruiter',
                          assetPath: 'assets/images/CV.png',
                          color: Color(0xff0038FF),
                          borderColor: Color(0xff0038FF),
                        ),
                        SizedBox(height: 20),
                        HoverableOptionCard(
                          title: "I'm a job-seeker, looking for work",
                          userType: 'job-seeker',
                          assetPath: 'assets/images/Hired.png',
                          color: Color(0xffFD7206),
                          borderColor: Color(0xffFD7206),
                        ),
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
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
                  );

        return Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          color: Colors.white,
          child: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButtonback(
                        onPressed: onToggle,
                        iconImage:
                            const AssetImage('assets/images/backbutton.png'),
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  userOptionResponsiveness,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
