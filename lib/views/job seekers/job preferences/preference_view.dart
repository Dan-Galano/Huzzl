import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/01%20location.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/02%20minimum_pay.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03%20job_titles.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/04%20resume.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/04b%20resume_manual.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Galano', scaffoldBackgroundColor: Colors.white),
      home: PreferenceViewPage(
        userUid: 'sampleUID',
      )));
}

class PreferenceViewPage extends StatefulWidget {
  final String userUid; // Pass user's UID for saving to Firestore
  const PreferenceViewPage({super.key, required this.userUid});

  @override
  State<PreferenceViewPage> createState() => _PreferenceViewPageState();
}

class _PreferenceViewPageState extends State<PreferenceViewPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int noOfPages = 4;
  // Variables to hold data from each page
  // String? selectedLocation;
  Map<String, dynamic>? selectedLocation;
  // String? selectedPayRate;
  Map<String, dynamic>? selectedPayRate;
  List<String>? selectedJobTitles;
  Map<String, dynamic>? currentResumeOption;
  List? currentSelectedJobTitles;
//controllers

//location

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _gotoJobPref() {
    _pageController.jumpToPage(1);
  }

  // Save data to Firestore
  Future<void> _savePreferencesToFirestore() async {
    if (selectedLocation == null ||
        selectedPayRate == null ||
        selectedJobTitles == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please complete all preferences before submitting.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userUid)
          .set({
        'uid': widget.userUid,
        'role': 'jobseeker',
        'location': selectedLocation,
        'payRate': selectedPayRate,
        'jobTitles': selectedJobTitles,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully!')),
      );

      _nextPage(); // Navigate to the next page if successful
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving preferences: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBarLoginRegister(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                JobSeekerCongratulationsPage(goToJobPref: _gotoJobPref),
                LocationSelectorPage(
                  nextPage: _nextPage,
                  onSaveLocation: (location) {
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                  currentLocation: selectedLocation,
                  noOfPages: noOfPages,
                ),
                MinimumPayPage(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSavePay: (payRate) {
                    setState(() {
                      selectedPayRate = payRate;
                    });
                  },
                  currentPayRate: selectedPayRate,
                  noOfPages: noOfPages,
                ),
                JobTitlesPage(
                  nextPage: _nextPage, // Save and go to the next page
                  previousPage: _previousPage,
                  onSaveJobTitles: (jobTitles) {
                    setState(() {
                      currentSelectedJobTitles = jobTitles; // Update the state
                    });
                  },
                  currentSelectedJobTitles: currentSelectedJobTitles ?? [],
                  noOfPages: noOfPages,
                ),
                ResumePage(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                ),
                ResumePageManual(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
