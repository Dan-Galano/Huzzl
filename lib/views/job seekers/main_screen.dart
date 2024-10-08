// holds the navigation between JobSeekerHomeScreen and CompanyReviews

import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_reviews.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';
import 'package:huzzl_web/views/job%20seekers/my_reviews/my_reviews.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/views/job%20seekers/profile/02%20contact_information.dart';
import 'package:huzzl_web/views/job%20seekers/profile/03%20qualifications.dart';
import 'package:huzzl_web/views/job%20seekers/profile/04%20job_preferences.dart';
import 'package:huzzl_web/widgets/navbar/navbar_home.dart';

class JobseekerMainScreen extends StatefulWidget {
  @override
  JobseekerMainScreenState createState() => JobseekerMainScreenState();
}

class JobseekerMainScreenState extends State<JobseekerMainScreen> {
  int selectedIndex = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    JobSeekerHomeScreen(),
    CompanyReviews(),
    MyJobsView(),
    MyReviewsView(),
    ProfileScreen(),
    ContactInformationScreen(),
    QualificationsScreen(),
    JobPreferencesScreen(),
  ];

  void switchScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: NavBarHome(
          selectedIndex: selectedIndex,
          onItemTapped: _onNavBarItemTapped, // Pass the callback here
        ),
      ),
      body: _screens[selectedIndex], // Display the selected screen
    );
  }
}
