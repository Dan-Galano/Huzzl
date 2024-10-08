import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class JobPreferencesScreen extends StatefulWidget {
  const JobPreferencesScreen({super.key});

  @override
  State<JobPreferencesScreen> createState() => _JobPreferencesScreenState();
}

class _JobPreferencesScreenState extends State<JobPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(40),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButtonback(
                onPressed: () {
                  JobseekerMainScreenState? mainScreenState = context
                      .findAncestorStateOfType<JobseekerMainScreenState>();
                  mainScreenState?.switchScreen(4);
                },
                iconImage: const AssetImage('assets/images/backbutton.png'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 670,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Job preferences',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff202855),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Tell us the job details you\'re interested in to get better recommendations across huzzl.\n\nEmployers may see these preferences when your resume is set to searchable.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff202855),
                      fontFamily: 'Galano',
                    ),
                  ),
                  Gap(10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                        top: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading:
                          Image.asset('assets/images/prof-jobtitle-icon.png'),
                      title: Text(
                        "Add job title",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading: Image.asset('assets/images/portfolio-icon.png'),
                      title: Text(
                        "Add job types",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading: Image.asset('assets/images/clock-icon.png'),
                      title: Text(
                        "Add work schedules",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading: Image.asset('assets/images/add-pay-icon.png'),
                      title: Text(
                        "Add pay",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading: Image.asset('assets/images/loca-icon.png'),
                      title: Text(
                        "Add relocation",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffACACAC),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      leading: Image.asset('assets/images/home-blue-icon.png'),
                      title: Text(
                        "Add remote",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff202855),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_rounded,
                        size: 35,
                        color: Color(0xff202855),
                      ),
                      onTap: () {
                        // Navigate to qualifications screen
                      },
                    ),
                  ),
                  Gap(20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0038FF),
                          // padding: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15)),
                      child: const Text('Finish',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                  Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
