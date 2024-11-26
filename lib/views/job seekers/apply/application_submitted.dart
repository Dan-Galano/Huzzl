import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:provider/provider.dart';

class ApplicationSubmitted extends StatefulWidget {
  const ApplicationSubmitted({super.key});

  @override
  State<ApplicationSubmitted> createState() => _ApplicationSubmittedState();
}

class _ApplicationSubmittedState extends State<ApplicationSubmitted> {
  String? loggedInUserId;
  @override
  Widget build(BuildContext context) {
    loggedInUserId =
        Provider.of<UserProvider>(context, listen: false).loggedInUserId;
    return Scaffold(
      body: Column(
        children: [
          // const NavBarLoginRegister(),
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
                      'Your application has been submitted!',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'This employer typically responds to application between 1-2 days.',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Gap(15),
                    SizedBox(
                      width: 430,
                      child: BlueOutlinedBoxButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => JobseekerMainScreen(
                              uid: loggedInUserId!,
                            ),
                          ));
                        },
                        text: 'Continue to search jobs',
                      ),
                    ),
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
