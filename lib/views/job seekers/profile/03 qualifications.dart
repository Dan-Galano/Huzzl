import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

// void main() {
//   runApp(Qual());
// }

// class Qual extends StatelessWidget {
//   const Qual({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: QualificationsScreen(),
//       ),
//     );
//   }
// }

class QualificationsScreen extends StatefulWidget {
  const QualificationsScreen({super.key});

  @override
  State<QualificationsScreen> createState() => _QualificationsScreenState();
}

class _QualificationsScreenState extends State<QualificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            alignment: Alignment.centerLeft,
            width: 860,
            child: IconButtonback(
              onPressed: () {
                JobseekerMainScreenState? mainScreenState =
                    context.findAncestorStateOfType<JobseekerMainScreenState>();
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
                  'Qualifications',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff202855),
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(10),
                Text(
                  'We use these details to show you jobs that match your unique skills and experience.',
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
                    leading: Image.asset('assets/images/portfolio-icon.png'),
                    title: Text(
                      "Add most recent work experience",
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
                    leading: Image.asset('assets/images/educ-icon.png'),
                    title: Text(
                      "Add education",
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
                    leading: Image.asset('assets/images/medal-icon.png'),
                    title: Text(
                      "Add skills",
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
                    leading: Image.asset('assets/images/medal-icon.png'),
                    title: Text(
                      "Add licenses",
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
                    leading: Image.asset('assets/images/medal-icon.png'),
                    title: Text(
                      "Add certifications",
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    child: const Text('Finish',
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
          ),
        ),
      ],
    );
  }
}