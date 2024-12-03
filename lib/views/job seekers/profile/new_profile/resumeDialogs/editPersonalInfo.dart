import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/string_formatter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class EditPersonalInfoDialog extends StatefulWidget {
  final bool isInitialSetup;
  const EditPersonalInfoDialog({
    super.key,
    required this.isInitialSetup,
  });
  @override
  _EditPersonalInfoDialogState createState() => _EditPersonalInfoDialogState();
}

class _EditPersonalInfoDialogState extends State<EditPersonalInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  // New controllers for the location fields
  late TextEditingController _regionController;
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _barangayController;
  late TextEditingController _otherLocationController;

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    _fnameController = TextEditingController(text: resumeProvider.fname ?? '');
    _lnameController = TextEditingController(text: resumeProvider.lname ?? '');
    _phoneController =
        TextEditingController(text: resumeProvider.pnumber ?? '');
    _emailController = TextEditingController(text: resumeProvider.email ?? '');

    // Initialize the location fields with the current data
    _regionController = TextEditingController(
        text: resumeProvider.locationData?['regionName'] ?? '');
    _provinceController = TextEditingController(
        text: resumeProvider.locationData?['provinceName'] ?? '');
    _cityController = TextEditingController(
        text: resumeProvider.locationData?['cityName'] ?? '');
    _barangayController = TextEditingController(
        text: resumeProvider.locationData?['barangayName'] ?? '');
    _otherLocationController = TextEditingController(
        text: resumeProvider.locationData?['otherLocation'] ?? '');
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _regionController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _barangayController.dispose();
    _otherLocationController.dispose();
    super.dispose();
  }

  void _savePersonalInfo() async {
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
      resumeProvider.updateName(
        _fnameController.text,
        _lnameController.text,
      );
      resumeProvider.updatePhoneNumber(_phoneController.text);
      resumeProvider.updateEmail(_emailController.text);

      // Update location fields
      resumeProvider.updateLocation({
        'regionName': _regionController.text,
        'provinceName': _provinceController.text,
        'cityName': _cityController.text,
        'barangayName': _barangayController.text,
        'otherLocation': _otherLocationController.text,
      });

      // Prepare the updated resume data
      Map<String, dynamic> updatedResumeData = {
        'fname': _fnameController.text.toLowerCaseTrimmed().toCapitalCase(),
        'lname': _lnameController.text.toLowerCaseTrimmed().toCapitalCase(),
        'fullName':
            '${_fnameController.text.toLowerCaseTrimmed().toCapitalCase()} ${_lnameController.text.toLowerCaseTrimmed().toCapitalCase()}',
        'pnumber': _phoneController.text,
        'email': _emailController.text.toLowerCaseTrimmed(),
        'location': {
          'regionName':
              _regionController.text.toLowerCaseTrimmed().toTitleCase(),
          'provinceName':
              _provinceController.text.toLowerCaseTrimmed().toTitleCase(),
          'cityName': _cityController.text.toLowerCaseTrimmed().toTitleCase(),
          'barangayName':
              _barangayController.text.toLowerCaseTrimmed().toTitleCase(),
          'otherLocation': _otherLocationController.text
        },
        'updatedAt': DateTime.now(),
      };

      Map<String, dynamic> updatedUserData = {
        'firstName': _fnameController.text.toLowerCaseTrimmed().toCapitalCase(),
        'lastName': _lnameController.text.toLowerCaseTrimmed().toCapitalCase(),
        'fullName':
            '${_fnameController.text.toLowerCaseTrimmed().toCapitalCase()} ${_lnameController.text.toLowerCaseTrimmed().toCapitalCase()}',
        'phoneNumber': _phoneController.text,
        'email': _emailController.text.toLowerCaseTrimmed(),
        'selectedLocation': {
          'regionName':
              _regionController.text.toLowerCaseTrimmed().toTitleCase(),
          'provinceName':
              _provinceController.text.toLowerCaseTrimmed().toTitleCase(),
          'cityName': _cityController.text.toLowerCaseTrimmed().toTitleCase(),
          'barangayName':
              _barangayController.text.toLowerCaseTrimmed().toTitleCase(),
          'otherLocation':
              _otherLocationController.text.toLowerCaseTrimmed().toTitleCase(),
        },
        'updatedAt': DateTime.now(),
      };
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
          "✓ You edited your personal info.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        return;
      }
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRef = firestore.collection('users');
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
        await usersRef
            .doc(userId)
            .set(updatedUserData, SetOptions(merge: true));

        print('Personal info saved and resume and user updated successfully!');

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
          "✓ Your personal info has been saved.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );

        // Optionally, reload the resume data after saving
        await resumeProvider.getResumeByJobSeekerId(userId);
      } catch (e) {
        print('Error saving personal info: $e');
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
          "⚠︎ Failed to save your personal info. Try again later.",
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
                "Edit Personal Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF373030),
                ),
              ),
              SizedBox(height: 20),
              // First and Last Name in same row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lnameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Phone Number and Email
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Region, Province, City in same row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _regionController,
                      decoration: InputDecoration(
                        labelText: 'Region',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _provinceController,
                      decoration: InputDecoration(
                        labelText: 'Province (leave blank if NCR)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Barangay and Other Location in same row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barangayController,
                      decoration: InputDecoration(
                        labelText: 'Barangay',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _otherLocationController,
                      decoration: InputDecoration(
                        labelText: 'House/Building No., Street',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
                    onPressed: _savePersonalInfo,
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
