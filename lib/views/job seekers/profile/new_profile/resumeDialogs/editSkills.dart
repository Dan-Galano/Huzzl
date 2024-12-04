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

class EditSkillsDialog extends StatefulWidget {
  final bool isInitialSetup;
  const EditSkillsDialog({
    super.key,
    required this.isInitialSetup,
  });
  @override
  _EditSkillsDialogState createState() => _EditSkillsDialogState();
}

class _EditSkillsDialogState extends State<EditSkillsDialog> {
  List<String> selectedSkills = []; // Store selected skills

// TextEditingController to manage input text in the TextField
  TextEditingController _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch and initialize selectedSkills from resumeProvider
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    if (resumeProvider.selectedSkills != null) {
      selectedSkills = List.from(
          resumeProvider.selectedSkills!); // Initialize with existing skills
    }
  }

  @override
  void dispose() {
    _skillsController.dispose();
    super.dispose();
  }

  void _saveSkills() async {
    if (selectedSkills.length < 3) {
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
        "⚠︎ You must add up to 3 skills.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    } else {
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
      resumeProvider.updateSkills(selectedSkills);

      // Prepare the updated resume data
      Map<String, dynamic> updatedResumeData = {
        'skills': selectedSkills,
        'updatedAt': DateTime.now(),
      };        if (widget.isInitialSetup == true) {
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
          "✓ You edited your skills.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        return;
      }


      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRefResume =
            firestore.collection('users').doc(userId).collection('resume');

        QuerySnapshot existingResumes = await usersRefResume.get();

        if (existingResumes.docs.isEmpty) {
          DocumentReference newResumeDoc =
              await usersRefResume.add(updatedResumeData);
        } else {
          await usersRefResume
              .doc(existingResumes.docs.first.id)
              .set(updatedResumeData, SetOptions(merge: true));
        }

        print('skils saved and resume updated successfully!');

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
          "✓ Your skills has been saved.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );

        // Optionally, reload the resume data after saving
        await resumeProvider.getResumeByJobSeekerId(userId);
      } catch (e) {
        print('Error saving skills: $e');
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

  Widget buildAddSkill(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // TextField for input
            Expanded(
              child: TextField(
                controller: _skillsController,
                decoration: InputDecoration(
                  hintText: 'e.g. Problem-Solving',
                  hintStyle: TextStyle(
                      fontFamily: 'Galano', fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // Trigger a rebuild when text changes (for enabling/disabling the "Add" button)
                  });
                },
              ),
            ),

            // "Add" button: only shows if there's text in the field
            if (_skillsController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  String skill = _skillsController.text.trim();

                  if (skill.isNotEmpty &&
                      !selectedSkills.any((selected) =>
                          selected.toLowerCase() == skill.toLowerCase())) {
                    setState(() {
                      selectedSkills.add(skill); // Add skill to selected list
                    });
                  }

                  // Clear the input field after adding
                  _skillsController.clear();
                },
              ),
          ],
        ),
        SizedBox(height: 30),
        // Display selected skills as scrollable chips in a Wrap layout
        Container(
          height: 270, // Constrained height for the scrollable space
          width: double.infinity,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 15.0, // Horizontal space between chips
              runSpacing: 15.0, // Vertical space between rows of chips
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  onDeleted: () {
                    setState(() {
                      selectedSkills.remove(skill); // Remove from selected list
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
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
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Edit Skills",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF373030),
                ),
              ),
            ),
            SizedBox(height: 20),
            buildAddSkill(setState), SizedBox(height: 30),
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
                  onPressed: _saveSkills,
                  text: 'Save changes',
                  width: 200,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
