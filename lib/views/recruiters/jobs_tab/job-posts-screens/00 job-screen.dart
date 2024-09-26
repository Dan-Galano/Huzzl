import 'package:flutter/material.dart';
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

class JobScreens extends StatefulWidget {
  const JobScreens({super.key});

  @override
  State<JobScreens> createState() => _JobScreensState();
}

class _JobScreensState extends State<JobScreens> {
  PageController _pageController = PageController();
  int _currentPage = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: PageView(
          controller: _pageController,
          children: [
            JobTab(postJob: _goToPostJob),
            JobPosts(
              nextPage: _nextPage,
              cancel: _goToJobTab,
            ),
            JobDetails(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            JobSkills(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            JobPay(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            JobApplicationPreferences(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            JobHireSettings(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            JobPreScreenApplicants(
              nextPage: _nextPage,
              previousPage: _previousPage,
              cancel: _goToJobTab,
            ),
            EditJobDetails(nextPage: _nextPage, previousPage: _previousPage),
            JobCongratulationPage(
              goBack: _goToJobTab,
            ),
          ],
        ))
      ],
    );
  }
}
