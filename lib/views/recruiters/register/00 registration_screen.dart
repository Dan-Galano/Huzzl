import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/01%20company_profile.dart';
import 'package:huzzl_web/views/recruiters/register/03%20hiring_manager.dart';
import 'package:huzzl_web/views/recruiters/register/05%20details_hiring_manager.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterRegistrationScreen extends StatefulWidget {
  RecruiterRegistrationScreen({super.key});

  @override
  State<RecruiterRegistrationScreen> createState() =>
      _RecruiterRegistrationScreenState();
}

class _RecruiterRegistrationScreenState
    extends State<RecruiterRegistrationScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
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
          const NavBarLoginRegister(),
          Expanded(
              child: PageView(
            controller: _pageController,
            children: [
              CompanyProfileScreen(nextPage: _nextPage),
              HiringManagerProfileScreen(
                  nextPage: _nextPage, previousPage: _previousPage),
              AccountHiringManagerScreen(previousPage: _previousPage),
            ],
          ))
        ],
      ),
    );
  }
}
