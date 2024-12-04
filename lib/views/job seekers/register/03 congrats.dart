import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:provider/provider.dart';

class JobSeekerCongratulationsPage extends StatefulWidget {
  final VoidCallback goToJobPref;
  const JobSeekerCongratulationsPage({super.key, required this.goToJobPref});

  @override
  State<JobSeekerCongratulationsPage> createState() => _JobSeekerCongratulationsPageState();
}

class _JobSeekerCongratulationsPageState extends State<JobSeekerCongratulationsPage> {

  void _submitPreferences() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }

    Map<String, dynamic> jobPreferences = {
      'selectedLocation': appState.selectedLocation,
      'selectedPayRate': appState.selectedPayRate,
      'currentSelectedJobTitles': appState.currentSelectedJobTitles,
      'uid': userId,
    };

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRef = firestore.collection('users');

      await usersRef.doc(userId).set(jobPreferences, SetOptions(merge: true));
      print('Job preferences saved successfully!');

      // Show loading dialog
      _showLoadingDialog(context);

      // Delay for 3 seconds to keep the dialog visible before navigating
      await Future.delayed(Duration(seconds: 3));

      // Navigate to the next screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(uid: userId)),
      );
    } catch (e) {
      print('Error saving job preferences: $e');
    }
  }

    void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Loading, please wait...',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      'Congratulations! Your account has been created.',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Answer a few questions and start building your profile',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "It only takes 3-5 minutes and you can edit it later. We'll save as you go.",
                      // textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: 20,
                        // ),
                        TextButton(
                          child: Text("Skip for now",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                          onPressed:_submitPreferences,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 170,
                          child: ElevatedButton(
                            onPressed:  (){
                              
                          Provider.of<LocationProvider>(context, listen: false).resetLocationProvider();
                          Provider.of<ResumeProvider>(context, listen: false).resetProviderExceptContactInfo();
                              widget.goToJobPref();},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0038FF),
                              padding: EdgeInsets.all(20),
                            ),
                            child: const Text('Get Started',
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

                    // SizedBox(
                    //   width: 430,
                    //   child: BlueOutlinedBoxButton(
                    //     onPressed: () {},
                    //     text: 'Continue',
                    //   ),
                    // ),
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
