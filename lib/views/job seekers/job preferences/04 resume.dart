import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:provider/provider.dart';

class ResumePage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  const ResumePage({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
  });

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
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

  void _submitPreferencesSkipAll() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }

    Map<String, dynamic> jobPreferences = {
      'selectedLocation': null,
      'selectedPayRate': null,
      'currentSelectedJobTitles': null,
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 400.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '4/${widget.noOfPages}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      TextButton(
                        child: Text("Skip all",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        onPressed: _submitPreferencesSkipAll,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Let's set up your ",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'huzzl ',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.orange,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'resume',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'This helps us create a personalized resume to match you with the best job opportunities.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonList(
                    buttonData: [
                      {
                        'icon': Icons.upload_file,
                        'label': 'Upload your resume',
                        'onPressed': (BuildContext context) {
                          // Add your onPressed logic here
                          print("Upload your own resume");
                        },
                      },
                      {
                        'icon': Icons.edit,
                        'label': 'Fill up manually',
                        'onPressed': (BuildContext context) {
                          widget.nextPage();
                          print("Fill up manually");
                        },
                      },
                    ],
                  ),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 230,
                          child: BlueFilledCircleButton(
                            onPressed: _submitPreferences,
                            text: "Skip, I'll do it later",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}
