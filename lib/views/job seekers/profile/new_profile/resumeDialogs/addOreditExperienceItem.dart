import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/education_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/experience_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/timeperiod_picker.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class AddOrEditExperienceItem extends StatefulWidget {
  final List<ExperienceEntry> experienceEntries;
  final ExperienceEntry entry;
  final bool isEditing;
  final bool isInitialSetup;

  const AddOrEditExperienceItem({
    Key? key,
    required this.entry,
    required this.experienceEntries,
    required this.isInitialSetup,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _AddOrEditExperienceItemState createState() =>
      _AddOrEditExperienceItemState();
}

class _AddOrEditExperienceItemState extends State<AddOrEditExperienceItem> {
  final _formKey = GlobalKey<FormState>();
  late ExperienceEntry entry;
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

  void _addExperienceEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        _showLoadingDialog(context);
        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        String? userId = userProvider.loggedInUserId;

        if (userId == null) {
          print('User not logged in!');
          return;
        }

        // Create a new ExperienceEntry object with the form data
        ExperienceEntry newEntry = ExperienceEntry()
          ..jobTitle = entry.jobTitleController.text
          ..companyName = entry.companyNameController.text
          ..companyAddress = entry.companyAddressController.text
          ..responsibilitiesAchievements =
              entry.responsibilitiesAchievementsController.text
          ..fromSelectedMonth = entry.fromSelectedMonth
          ..fromSelectedYear = entry.fromSelectedYear
          ..toSelectedMonth = entry.toSelectedMonth
          ..toSelectedYear = entry.toSelectedYear
          ..isPresent = entry.isPresent;

        // Update the experienceEntries list in the provider
        widget.experienceEntries.add(newEntry);

        ExperienceSorter.sortExperienceEntries(widget.experienceEntries);
        resumeProvider.updateExperienceEntries(widget.experienceEntries);
        if (widget.isInitialSetup == true) {
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
            "✓ You added another work experience.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
          return;
        }

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRef = firestore.collection('users');
        CollectionReference usersRefResume =
            usersRef.doc(userId).collection('resume');

        // Fetch existing resume document
        QuerySnapshot existingResumes = await usersRefResume.get();

        if (existingResumes.docs.isNotEmpty) {
          // If the resume exists, update the education field in the document
          await usersRefResume
              .doc(existingResumes.docs.first.id) // Get the first document ID
              .set({
            'education': widget.experienceEntries
                .map((e) => {
                      'jobTitle': e.jobTitle,
                      'companyName': e.companyName,
                      'companyAddress': e.companyAddress,
                      'responsibilitiesAchievements':
                          e.responsibilitiesAchievements,
                      'fromSelectedMonth': e.fromSelectedMonth,
                      'fromSelectedYear': e.fromSelectedYear,
                      'toSelectedMonth': e.toSelectedMonth,
                      'toSelectedYear': e.toSelectedYear,
                      'isPresent': e.isPresent,
                    })
                .toList()
          }, SetOptions(merge: true)); // Merge with existing document

          print('Education updated successfully!');

          // Reload resume data to reflect changes in the app
          await resumeProvider.getResumeByJobSeekerId(userId);

          ExperienceSorter.sortExperienceEntries(widget.experienceEntries);
          // Notify listeners to update UI with the new data
          context
              .read<ResumeProvider>()
              .updateExperienceEntries(widget.experienceEntries);

          // Close the dialog
          Navigator.pop(context); // Close the loading dialog
          Navigator.pop(context); // Close the edit/add dialog

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
            "✓ Your education entry has been saved.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
        } else {
          print('No resume document found for user: $userId');
        }
      } catch (e) {
        print("Error adding education entry: $e");
        Navigator.pop(context); // Close the loading dialog
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
        EasyLoading.showToast("⚠︎ Failed to save changes. Please try again.");
      }
    }
  }

  void _editExperienceEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        _showLoadingDialog(context);

        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        String? userId = userProvider.loggedInUserId;

        if (userId == null) {
          print('User not logged in!');
          return;
        }

        // Update the entry with the values from the form fields
        entry.jobTitle = entry.jobTitleController.text;
        entry.companyName = entry.companyNameController.text;
        entry.companyAddress = entry.companyAddressController.text;
        entry.responsibilitiesAchievements =
            entry.responsibilitiesAchievementsController.text;
        entry.fromSelectedMonth = entry.fromSelectedMonth;
        entry.fromSelectedYear = entry.fromSelectedYear;
        entry.toSelectedMonth = entry.toSelectedMonth;
        entry.toSelectedYear = entry.toSelectedYear;
        entry.isPresent = entry.isPresent;

        // Update the experienceEntries list in the provider
        widget.experienceEntries[
            widget.experienceEntries.indexOf(widget.entry)] = entry;

        ExperienceSorter.sortExperienceEntries(widget.experienceEntries);
        resumeProvider.updateExperienceEntries(widget.experienceEntries);
        if (widget.isInitialSetup == true) {
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
            "✓ You edited a work experience.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
          return;
        }

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRef = firestore.collection('users');
        CollectionReference usersRefResume =
            usersRef.doc(userId).collection('resume');

        // Fetch existing resume document
        QuerySnapshot existingResumes = await usersRefResume.get();

        if (existingResumes.docs.isNotEmpty) {
          // If the resume exists, update the education field in the document
          await usersRefResume
              .doc(existingResumes.docs.first.id) // Get the first document ID
              .set({
            'education': widget.experienceEntries
                .map((e) => {
                      'jobTitle': e.jobTitle,
                      'companyName': e.companyName,
                      'companyAddress': e.companyAddress,
                      'responsibilitiesAchievements':
                          e.responsibilitiesAchievements,
                      'fromSelectedMonth': e.fromSelectedMonth,
                      'fromSelectedYear': e.fromSelectedYear,
                      'toSelectedMonth': e.toSelectedMonth,
                      'toSelectedYear': e.toSelectedYear,
                      'isPresent': e.isPresent,
                    })
                .toList()
          }, SetOptions(merge: true)); // Merge with existing document

          print('Education updated successfully!');

          // Reload resume data to reflect changes in the app
          await resumeProvider.getResumeByJobSeekerId(userId);

          ExperienceSorter.sortExperienceEntries(widget.experienceEntries);
          // Notify listeners to update UI with the new data
          context
              .read<ResumeProvider>()
              .updateExperienceEntries(widget.experienceEntries);

          // Close the dialog
          Navigator.pop(context); // Close the loading dialog
          Navigator.pop(context); // Close the edit/add dialog

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
            "✓ Your work experience has been saved.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
        } else {
          print('No resume document found for user: $userId');
        }
      } catch (e) {
        print("Error editing education entry: $e");
        Navigator.pop(context); // Close the loading dialog
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
        EasyLoading.showToast("⚠︎ Failed to save changes. Please try again.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      entry = widget.entry;
      entry.jobTitleController.text = entry.jobTitle;
      entry.companyNameController.text = entry.companyName;
      entry.companyAddressController.text = entry.companyAddress;
      entry.responsibilitiesAchievementsController.text =
          entry.responsibilitiesAchievements.replaceAll('• ', '');
    } else {
      entry = ExperienceEntry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.only(top: 30, left: 30, right: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEditing
                          ? 'Edit Work Experience'
                          : 'Add Work Experience',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff373030),
                      ),
                    ),
                  ],
                ),
                Gap(20),

                // Degree Field
                Row(
                  children: [
                    Text(
                      'Job Title',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
                Gap(5),
                CustomTextFormField(
                  controller:
                      entry.jobTitleController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.jobTitle = value;
                    });
                  },
                  validator: (value) {
                    if (entry.jobTitleController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                Gap(20),

                // Company Name
                Row(
                  children: [
                    Text(
                      'Company Name',
                      style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                    ),
                    Text(' *',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ],
                ),
                Gap(5),
                CustomTextFormField(
                  controller: entry
                      .companyNameController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.companyName = value;
                    });
                  },
                  validator: (value) {
                    if (entry.companyNameController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                Gap(20),

                // company Address
                Row(
                  children: [
                    Text(
                      'Institution Address',
                      style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                    ),
                  ],
                ),
                Gap(5),
                CustomTextFormField(
                  controller: entry
                      .companyAddressController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.companyAddress = value;
                    });
                  },
                  validator: (value) {
                    if (entry.companyAddressController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                Gap(20),

                // Time Period
                Row(
                  children: [
                    Text(
                      'Time Period',
                      style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                    ),
                    Text(' *',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ],
                ),
                Gap(5),
                Row(
                  children: [
                    Checkbox(
                      value: entry.isPresent,
                      onChanged: (bool? value) {
                        setState(() {
                          entry.isPresent = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'Currently working here',
                      style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                    ),
                  ],
                ),
                Gap(10),
                Text(
                  'From',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
                Gap(5),
                Row(
                  children: [
                    Expanded(
                      child: TimePeriodPicker(
                        selectedMonth: entry.fromSelectedMonth,
                        selectedYear: entry.fromSelectedYear,
                        onMonthChanged: (month) {
                          setState(() {
                            entry.fromSelectedMonth = month;
                          });
                        },
                        onYearChanged: (year) {
                          setState(() {
                            entry.fromSelectedYear = year;
                          });
                        },
                        validatorMonth: (month) {
                          if (month == null) {
                            return 'Please select a month';
                          }
                          return null;
                        },
                        validatorYear: (year) {
                          if (year == null) {
                            return 'Please select a year';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Gap(10),

                if (!entry.isPresent) ...[
                  Text(
                    'To',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: TimePeriodPicker(
                          selectedMonth: entry.toSelectedMonth,
                          selectedYear: entry.toSelectedYear,
                          onMonthChanged: (month) {
                            setState(() {
                              entry.toSelectedMonth = month;
                            });
                          },
                          onYearChanged: (year) {
                            setState(() {
                              entry.toSelectedYear = year;
                            });
                          },
                          validatorMonth: (month) {
                            if (month == null) {
                              return 'Please select a month';
                            }
                            return null;
                          },
                          validatorYear: (year) {
                            if (year == null) {
                              return 'Please select a year';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                ],

                // Responsibilities and Achievements
                Text(
                  'Key Responsibilities and Achievements',
                  style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                ),
                Gap(5),
                CustomTextFormField(
                  maxLines: 10,
                  controller: entry.responsibilitiesAchievementsController,
                  onChanged: (value) {
                    setState(() {
                      entry.responsibilitiesAchievements = value
                          .split('\n')
                          .map((line) => line.trim())
                          .where((line) => line.isNotEmpty)
                          .map((line) => '• $line')
                          .join('\n');
                    });
                  },
                  validator: (value) {
                    if (entry
                        .responsibilitiesAchievementsController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                Gap(20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Gap(20),
                      BlueFilledCircleButton(
                        onPressed: widget.isEditing
                            ? () {
                                _editExperienceEntry();
                              }
                            : () {
                                _addExperienceEntry();
                              },
                        text: widget.isEditing
                            ? 'Save changes'
                            : 'Add this work experience',
                        width: widget.isEditing
                            ? 200 : 400,
                      )
                    ],
                  ),
                ),
                Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
