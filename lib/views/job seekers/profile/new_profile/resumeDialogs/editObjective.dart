import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class EditObjectiveDialog extends StatefulWidget {
  @override
  _EditObjectiveDialogState createState() => _EditObjectiveDialogState();
}

class _EditObjectiveDialogState extends State<EditObjectiveDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _objectiveController;

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    _objectiveController =
        TextEditingController(text: resumeProvider.objective ?? '');
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    super.dispose();
  }

  void _saveObjective() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog(context);
      final resumeProvider =
          Provider.of<ResumeProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? userId = userProvider.loggedInUserId;

      if (userId == null) {
        print('User not logged in!');
        return;
      }

      // Update the ResumeProvider with new values
      resumeProvider.updateObjective(
        _objectiveController.text,
      );

      // Prepare the updated resume data
      Map<String, dynamic> updatedResumeData = {
        'objective': _objectiveController.text,
        'updatedAt': DateTime.now(),
      };

      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRefResume =
            firestore.collection('users').doc(userId).collection('resume');

        // Fetch existing resume document
        QuerySnapshot existingResumes = await usersRefResume.get();

        if (existingResumes.docs.isEmpty) {
          // If no existing resume, add a new one
          DocumentReference newResumeDoc =
              await usersRefResume.add(updatedResumeData);
        } else {
          // If resume exists, update the first document with merged data
          await usersRefResume
              .doc(existingResumes.docs.first.id)
              .set(updatedResumeData, SetOptions(merge: true));
        }

        print('objective saved and resume updated successfully!');

        // Close the dialog
        Navigator.pop(context);
        Navigator.pop(context);

        // Optionally, show a success message
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "✓ Your objective has been saved.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );

        // Optionally, reload the resume data after saving
        await resumeProvider.getResumeByJobSeekerId(userId);
      } catch (e) {
        print('Error saving objective: $e');
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color(0xFfd74a4a)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "⚠︎ Failed to save objective. Try again later.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
      }
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

  int countWords(String text) {
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.only(top: 30, left: 30, right: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Objective",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF373030),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'A brief statement highlighting your career goals and key qualifications. (50-100 words)',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff373030),
                  fontFamily: 'Galano',
                  fontWeight: FontWeight.w100,
                ),
              ),
              Gap(40),
              CustomTextFormField(
                hintText:
                    "E.g., 'A results-driven marketing professional seeking to leverage expertise in social media strategy and content creation to help a growing tech company reach new customers.'",
                controller: _objectiveController,
                maxWords: 100,
                minWords: 50,
                maxLines: 10,
                validator: (value) {
                  if (_objectiveController.text.trim().isEmpty) {
                    return 'Objective is required';
                  }
                  if (countWords(_objectiveController.text.trim()!) < 50) {
                    return 'Please enter at least 50 words.';
                  }
                  if (countWords(_objectiveController.text.trim()!) > 100) {
                    return 'Please enter no more than 100 words.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // Save and Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  Gap(20),
                  BlueFilledCircleButton(
                    onPressed: _saveObjective,
                    text: 'Save changes',
                    width: 200,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
