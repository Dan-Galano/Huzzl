import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class ApplyWoResumeScreen extends StatefulWidget {
  const ApplyWoResumeScreen({super.key});

  @override
  State<ApplyWoResumeScreen> createState() => _ApplyWoResumeScreenState();
}

class _ApplyWoResumeScreenState extends State<ApplyWoResumeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(60),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButtonback(
                onPressed: () {
                  // backbutton action
                },
                iconImage: const AssetImage('assets/images/backbutton.png'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 670,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add a resume for the employer',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff202855),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Add a resume for the employer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff202855),
                      fontFamily: 'Galano',
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffACACAC),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(right: 8),
                    child: ResumeButton(
                      imageAsset: 'assets/images/upload.png',
                      title: "Upload Resume",
                      subtitle:
                          "Accepted file types PDF. (Use Huzzl's resume template)",
                      onTap: () {},
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff202855),
                      ),
                      subtitleStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Galano',
                        color: Colors.grey.shade600,
                      ),
                      rightIconAsset:
                          'assets/images/upload_arrow.png', // Right-side icon
                    ),
                  ),
                  Gap(20),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: Color(0xffACACAC),
                  //       width: 1.5,
                  //     ),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   padding: EdgeInsets.all(16),
                  //   margin: EdgeInsets.only(right: 8),
                  //   child: ResumeButton(
                  //     imageAsset: 'assets/images/upload.png',
                  //     title: "Apply without a resume",
                  //     subtitle: "Attach your resume.",
                  //     onTap: () {},
                  //     titleStyle: TextStyle(
                  //       fontSize: 16,
                  //       fontFamily: 'Galano',
                  //       fontWeight: FontWeight.w600,
                  //       color: Color(0xff202855),
                  //     ),
                  //     subtitleStyle: TextStyle(
                  //       fontSize: 12,
                  //       fontFamily: 'Galano',
                  //       color: Colors.grey.shade600,
                  //     ),
                  //     rightIconAsset:
                  //         'assets/images/upload_arrow.png', // Right-side icon
                  //   ),
                  // ),
                  // Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () {}, child: Text('Cancel')),
                      Gap(15),
                      SizedBox(
                        width: 130,
                        child: BlueFilledCircleButton(
                          onPressed: () {},
                          text: 'Next',
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
