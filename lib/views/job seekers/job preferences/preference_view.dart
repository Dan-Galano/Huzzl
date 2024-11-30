import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/01%20location.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/02%20minimum_pay.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03%20job_titles.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/04%20resume.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/autobuild_resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_contactInfo.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_experience.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_objective.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_skills.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_education.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/resume_summary.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ResumeProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AutoBuildResumeProvider()),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Galano',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: PreferenceViewPage(
          userUid: 'sampleUID',
        ),
      ),
    ),
  );
}

class PreferenceViewPage extends StatefulWidget {
  final String userUid;
  const PreferenceViewPage({super.key, required this.userUid});

  @override
  State<PreferenceViewPage> createState() => _PreferenceViewPageState();
}

class _PreferenceViewPageState extends State<PreferenceViewPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int noOfPages = 4;
  int noOfResumePages = 6;
  int totalLength = 10;
  Map<String, dynamic>? selectedLocation;
  Map<String, dynamic>? selectedPayRate;
  Map<String, dynamic>? currentResumeOption;
  List? currentSelectedJobTitles;
  List<String>? selectedSkills;

  void _nextPage() {
    if (_currentPage < totalLength) {
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

  @override
  void initState() {
    super.initState();
    final loggedInUserId = widget.userUid;
    Provider.of<UserProvider>(context, listen: false)
        .setLoggedInUserId(loggedInUserId);
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
                ResumePageContactInfo(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageObjective(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageSkills(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  selectedSkills: selectedSkills ?? [],
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageEducation(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageExperience(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageSummary(
                  nextPage: _nextPage,
                  previousPage: _previousPage,
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
