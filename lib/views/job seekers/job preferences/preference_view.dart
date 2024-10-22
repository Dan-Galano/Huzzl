import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/01%20location.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/02%20minimum_pay.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03%20job_titles.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class PreferenceViewPage extends StatefulWidget {
  const PreferenceViewPage({super.key});

  @override
  State<PreferenceViewPage> createState() => _PreferenceViewPageState();
}

class _PreferenceViewPageState extends State<PreferenceViewPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

    void _nextPage() {
    if (_currentPage < 4) {
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
    return Scaffold(
      body: Column(
        children: [
           NavBarLoginRegister(),
          Expanded(
              child: PageView(
            controller: _pageController,
            children: [
              JobSeekerCongratulationsPage(goToJobPref: _gotoJobPref),
              LocationSelectorPage(nextPage: _nextPage),
              MinimumPayPage(nextPage: _nextPage, previousPage: _previousPage),
              JobTitlesPage(nextPage: _nextPage, previousPage: _previousPage)
            ],
          ))
        ],
      ),
    );
  }
}