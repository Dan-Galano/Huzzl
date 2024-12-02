import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/autobuild_resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_contactInfo2.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_education2.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_experience2.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_objective2.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_skills2.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_summary2.dart';
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
        home: ResumeManuallyPageView(
          userUid: 'sampleUID',
        ),
      ),
    ),
  );
}

class ResumeManuallyPageView extends StatefulWidget {
  final String userUid;
  const ResumeManuallyPageView({super.key, required this.userUid});

  @override
  State<ResumeManuallyPageView> createState() => _ResumeManuallyPageViewState();
}

class _ResumeManuallyPageViewState extends State<ResumeManuallyPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int noOfPages = 6;
  int noOfResumePages = 6;
  int totalLength = 6;
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

  void jumpToPage(int pageNumber) {
    if (pageNumber >= 1 && pageNumber <= totalLength) {
      _pageController.jumpToPage(pageNumber);
    } else {
      print('Invalid page number: $pageNumber');
    }
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
                ResumePageContactInfo2(
                  nextPage: _nextPage,
                  previousPage: () {
                    Navigator.pop(context);
                  },
                  onSaveResumeSetup: (cresume) {
                    setState(() {
                      currentResumeOption = cresume;
                    });
                  },
                  currentResumeOption: currentResumeOption,
                  noOfPages: noOfPages,
                  noOfResumePages: noOfResumePages,
                ),
                ResumePageObjective2(
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
                ResumePageSkills2(
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
                ResumePageEducation2(
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
                ResumePageExperience2(
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
                ResumePageSummary2(
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
