import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/01%20job-posts.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/02%20job-details.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/03%20job-skills.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/04%20job-pay.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/05%20job-app-preference.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/06%20job-hire-settings.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/07%20job-pre-screen.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/08%20edit-job-details.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/09%20congrats.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/jobs-tab.dart';
import 'package:intl/intl.dart';

class JobScreens extends StatefulWidget {
  final List<Map<String, dynamic>> jobPostsData;
  final List<Candidate> candidates;
  final User user;
  final Map<String, dynamic> userData;
  final int initialIndex;
  const JobScreens({
    required this.candidates,
    required this.jobPostsData,
    required this.user,
    required this.userData,
    super.key, required this.initialIndex,
  });

  @override
  State<JobScreens> createState() => _JobScreensState();
}

class _JobScreensState extends State<JobScreens> {
  //UID
  User? user = FirebaseAuth.instance.currentUser;

  PageController _pageController = PageController();
  int _currentPage = 0;

  // first screen (Job Post)
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  String _selectedIndustry = '';
  String _numOfPeopleToHire = 'One person';
  String _numPeople = '';
  String _selectedRegion = '';
  String _selectedProvince = '';
  String _selectedCity = '';
  String _selectedBarangay = '';
  TextEditingController _otherLocation = TextEditingController();
  // 2nd screen (Job Details)
  String _selectedJobType = '';
  String _selectedHrsPerWeek = 'More than 30 hrs/week';
  // 3rd screen (Job Skills)
  List<String> _selectedSkills = [];
  // 4th screen (Job Pay)
  String selectedRate = '';
  TextEditingController minimumRate = TextEditingController();
  TextEditingController maximumRate = TextEditingController();
  List<String> _selectedSupPlay = [];
  // String selectedSupPlay = '';
  // 5th screen (Job App Preference)
  String resumeAnswer = 'Yes';
  String appDeadlineAns = 'Yes';
  DateTime? appDeadlineDate;
  // 6th screen (Hire Settings)
  // String selectedHiringTimeline = '';
  // 7th screen (Prescreen questions)
  List<String> preScreenQues = [];
  List<String> responsibilities = [];

  void _nextPage() {
    if (_currentPage < 9) {
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

  void _goToJobTab() {
    _pageController.jumpToPage(0);
  }

  void _goToPostJob() {
    _pageController.jumpToPage(1);
  }

  void _submitJobPostForm() {
    // ADD THE DB HERE
    print("Data: ${jobTitleController.text} ${jobDescriptionController.text}");

    // clear all values
    jobTitleController.clear();
    _selectedIndustry = '';
    jobDescriptionController.clear();
    _numOfPeopleToHire = 'One person'; // Reset to default value
    _numPeople = '';
    _selectedRegion = '';
    _selectedProvince = '';
    _selectedCity = '';
    _selectedBarangay = '';
    _otherLocation.clear();

    _selectedJobType = '';
    _selectedHrsPerWeek = 'More than 30 hrs/week'; // Reset to default value

    _selectedSkills.clear(); // Clear selected skills

    selectedRate = '';
    minimumRate.clear();
    maximumRate.clear();
    _selectedSupPlay.clear(); // Clear selected supplemental pay

    resumeAnswer = 'Yes'; // Reset to default value
    appDeadlineAns = 'Yes'; // Reset to default value
    appDeadlineDate = null; // Reset the date

    // selectedHiringTimeline = ''; // Clear hiring timeline
    preScreenQues.clear(); // Clear pre-screen questions
    // Go back to the Job tab
    _pageController.jumpToPage(9);
  }

  void _cancel() {
    // clears everything then go to job tab
    jobTitleController.clear();
    jobDescriptionController.clear();
    _selectedIndustry = '';
    _numOfPeopleToHire = 'One person'; // Reset to default value
    _numPeople = '';
    _selectedRegion = '';
    _selectedProvince = '';
    _selectedCity = '';
    _selectedBarangay = '';
    _otherLocation.clear();
    _selectedJobType = '';
    _selectedHrsPerWeek = 'More than 30 hrs/week'; // Reset to default value
    _selectedSkills.clear(); // Clear selected skills
    selectedRate = '';
    minimumRate.clear();
    maximumRate.clear();
    _selectedSupPlay.clear(); // Clear selected supplemental pay
    resumeAnswer = 'Yes'; // Reset to default value
    appDeadlineAns = 'Yes'; // Reset to default value
    appDeadlineDate = null; // Reset the date
    // selectedHiringTimeline = ''; // Clear hiring timeline
    preScreenQues.clear(); // Clear pre-screen questions
    // Go back to the Job tab
    _pageController.jumpToPage(0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    _numOfPeopleToHire = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: PageView(
          controller: _pageController,
          children: [
            JobTab(
              candidates: widget.candidates,
              postJob: _goToPostJob,
              jobPostsData: widget.jobPostsData,
              user: widget.user,
              initialIndex: widget.initialIndex,
            ),
            JobPosts(
              nextPage: _nextPage,
              cancel: _cancel,
              jobTitleController: jobTitleController,
              selectedIndustry: _selectedIndustry,
              onselectedIndustryChanged: (value) =>
                  setState(() => _selectedIndustry = value!),
              numOfPeopleToHire: _numOfPeopleToHire,
              onNumOfPeopleToHireChanged: (value) =>
                  setState(() => _numOfPeopleToHire = value!),
              onNumPeopleChanged: (value) =>
                  setState(() => _numPeople = value!),
              onRegionChanged: (value) =>
                  setState(() => _selectedRegion = value!),
              onProvinceChanged: (value) =>
                  setState(() => _selectedProvince = value!),
              onCityChanged: (value) => setState(() => _selectedCity = value!),
              onBarangayChanged: (value) =>
                  setState(() => _selectedBarangay = value!),
              otherLocation: _otherLocation,
              jobDescriptionController: jobDescriptionController,
            ),
            JobDetails(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _cancel,
              selectedJobType: _selectedJobType,
              onJobTypeChanged: (value) =>
                  setState(() => _selectedJobType = value!),
              hrsPerWeek: _selectedHrsPerWeek,
              onHrsPerWeekChanged: (value) =>
                  setState(() => _selectedHrsPerWeek = value!),
            ),
            JobSkills(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _cancel,
              selectedSkills: _selectedSkills,
              responsibilities: responsibilities,
            ),
            JobPay(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _cancel,
              minimumRate: minimumRate,
              maximumRate: maximumRate,
              selectedRate: selectedRate,
              onSelectedRateChanged: (value) =>
                  setState(() => selectedRate = value!),
              selectedSupPay: _selectedSupPlay,
              // onSelectedSuppayChanged: (value) =>
              //     setState(() => _selectedSupPlay = value),
            ),
            JobApplicationPreferences(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _cancel,
              resumeAnswer: resumeAnswer,
              onResumeAnsChanged: (value) =>
                  setState(() => resumeAnswer = value!),
              appDeadlineAns: appDeadlineAns,
              onAppDeadlineAnsChanged: (value) =>
                  setState(() => appDeadlineAns = value!),
              selectedAppDeadlineDate: appDeadlineDate ?? DateTime.now(),
              onAppDeadlineDateChanged: (value) =>
                  setState(() => appDeadlineDate = value!),
            ),
            // JobHireSettings(
            //   nextPage: _nextPage,
            //   previousPage: _previousPage,
            //   cancel: _cancel,
            //   selectedTimeline: selectedHiringTimeline,
            //   onHiringTimelineChanged: (value) =>
            //       setState(() => selectedHiringTimeline = value!),
            // ),
            JobPreScreenApplicants(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _cancel,
              prescreenQuestions: preScreenQues,
            ),
            EditJobDetails(
              submitForm: _submitJobPostForm,
              previousPage: _previousPage,
              jobTitleController: jobTitleController,
              industry: _selectedIndustry,
              numOfPeopleToHire: _numOfPeopleToHire,
              numPeople: _numPeople,
              region: _selectedRegion,
              province: _selectedProvince,
              city: _selectedCity,
              barangay: _selectedBarangay,
              otherLocation: _otherLocation,
              jobDescriptionController: jobDescriptionController,
              jobType: _selectedJobType,
              schedule: _selectedHrsPerWeek,
              skills: _selectedSkills,
              responsibilities: responsibilities,
              selectedRate: selectedRate,
              minRate: minimumRate,
              maxRate: maximumRate,
              supplementalPay: _selectedSupPlay,
              resumeRequiredAns: resumeAnswer,
              appDeadlineAns: appDeadlineAns,
              appDeadlineDate: appDeadlineDate ?? DateTime.now(),
              // hiringTimeline: selectedHiringTimeline,
              prescreenQuestions: preScreenQues,
              user: widget.user,
              userData: widget.userData,
            ),
            JobCongratulationPage(
              goBack: _cancel, // clear niya everything tas balik sa Job tab
            ),
          ],
        ))
      ],
    );
  }
}
