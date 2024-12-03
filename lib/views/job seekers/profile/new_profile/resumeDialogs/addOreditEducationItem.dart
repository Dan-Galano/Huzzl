import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/education_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/timeperiod_picker.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class AddOrEditEducationItem extends StatefulWidget {
  final List<EducationEntry> educationEntries;
  final EducationEntry entry;
  final bool isEditing;
  final bool isInitialSetup;

  const AddOrEditEducationItem({
    Key? key,
    required this.entry,
    required this.educationEntries,
    required this.isInitialSetup,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _AddOrEditEducationItemState createState() => _AddOrEditEducationItemState();
}

class _AddOrEditEducationItemState extends State<AddOrEditEducationItem> {
  final _formKey = GlobalKey<FormState>();
  late EducationEntry entry;
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

  void _addEducationEntry() async {
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

        // Create a new EducationEntry object with the form data
        EducationEntry newEntry = EducationEntry()
          ..degree = entry.degreeController.text
          ..institutionName = entry.institutionNameController.text
          ..institutionAddress = entry.institutionAddressController.text
          ..honorsOrAwards = entry.honorsOrAwardsController.text
          ..fromSelectedMonth = entry.fromSelectedMonth
          ..fromSelectedYear = entry.fromSelectedYear
          ..toSelectedMonth = entry.toSelectedMonth
          ..toSelectedYear = entry.toSelectedYear
          ..isPresent = entry.isPresent;

        // Update the educationEntries list in the provider
        widget.educationEntries.add(newEntry);

        EducationSorter.sortEducationEntries(widget.educationEntries);
        resumeProvider.updateEducationEntries(widget.educationEntries);
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
            "✓ You added an institution.",
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
            'education': widget.educationEntries
                .map((e) => {
                      'degree': e.degree,
                      'institutionName': e.institutionName,
                      'institutionAddress': e.institutionAddress,
                      'honorsOrAwards': e.honorsOrAwards,
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

          EducationSorter.sortEducationEntries(widget.educationEntries);
          // Notify listeners to update UI with the new data
          context
              .read<ResumeProvider>()
              .updateEducationEntries(widget.educationEntries);

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

  void _editEducationEntry() async {
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
        entry.degree = entry.degreeController.text;
        entry.institutionName = entry.institutionNameController.text;
        entry.institutionAddress = entry.institutionAddressController.text;
        entry.honorsOrAwards = entry.honorsOrAwardsController.text;
        entry.fromSelectedMonth = entry.fromSelectedMonth;
        entry.fromSelectedYear = entry.fromSelectedYear;
        entry.toSelectedMonth = entry.toSelectedMonth;
        entry.toSelectedYear = entry.toSelectedYear;
        entry.isPresent = entry.isPresent;

        // Update the educationEntries list in the provider
        widget.educationEntries[widget.educationEntries.indexOf(widget.entry)] =
            entry;

        EducationSorter.sortEducationEntries(widget.educationEntries);
        resumeProvider.updateEducationEntries(widget.educationEntries);
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
            "✓ You edited your education.",
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
            'education': widget.educationEntries
                .map((e) => {
                      'degree': e.degree,
                      'institutionName': e.institutionName,
                      'institutionAddress': e.institutionAddress,
                      'honorsOrAwards': e.honorsOrAwards,
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

          EducationSorter.sortEducationEntries(widget.educationEntries);
          // Notify listeners to update UI with the new data
          context
              .read<ResumeProvider>()
              .updateEducationEntries(widget.educationEntries);

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
      entry.degreeController.text = entry.degree;
      entry.institutionNameController.text = entry.institutionName;
      entry.institutionAddressController.text = entry.institutionAddress;
      entry.honorsOrAwardsController.text =
          entry.honorsOrAwards.replaceAll('• ', '');
    } else {
      entry = EducationEntry();
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
                      widget.isEditing ? 'Edit Institution' : 'Add Institution',
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
                      'Degree/Qualification/Level of Education',
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
                      entry.degreeController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.degree = value;
                    });
                  },
                  validator: (value) {
                    if (entry.degreeController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                Gap(20),

                // Institution Name
                Row(
                  children: [
                    Text(
                      'Institution Name',
                      style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                    ),
                    Text(' *',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ],
                ),
                Gap(5),
                CustomTextFormField(
                  controller: entry
                      .institutionNameController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.institutionName = value;
                    });
                  },
                  validator: (value) {
                    if (entry.institutionNameController.text.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                Gap(20),

                // Institution Address
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
                      .institutionAddressController, // Use controller from the model
                  onChanged: (value) {
                    setState(() {
                      entry.institutionAddress = value;
                    });
                  },
                  validator: (value) {
                    if (entry.institutionAddressController.text.isEmpty) {
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
                      'Currently enrolled',
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

                // Honors and Awards
                Text(
                  'Honors and Awards',
                  style: TextStyle(fontSize: 16, color: Color(0xff373030)),
                ),
                Gap(5),
                CustomTextFormField(
                  maxLines: 10,
                  controller: entry.honorsOrAwardsController,
                  onChanged: (value) {
                    setState(() {
                      entry.honorsOrAwards = value
                          .split('\n')
                          .map((line) => line.trim())
                          .where((line) => line.isNotEmpty)
                          .map((line) => '• $line')
                          .join('\n');
                    });
                  },
                  validator: (value) {
                    if (entry.honorsOrAwardsController.text.isEmpty) {
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
                                _editEducationEntry();
                              }
                            : () {
                                _addEducationEntry();
                              },
                        text: widget.isEditing
                            ? 'Save changes'
                            : 'Add this education',
                        width: 200,
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
