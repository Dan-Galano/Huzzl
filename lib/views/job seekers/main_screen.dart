// holds the navigation between JobSeekerHomeScreen and CompanyReviews

import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_reviews.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';
import 'package:huzzl_web/views/job%20seekers/my_reviews/my_reviews.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/widgets/navbar/navbar_home.dart';

class JobseekerMainScreen extends StatefulWidget {
  @override
  _JobseekerMainScreenState createState() => _JobseekerMainScreenState();
}

class _JobseekerMainScreenState extends State<JobseekerMainScreen> {
  int selectedIndex = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    JobSeekerHomeScreen(),
    CompanyReviews(),
    MyJobsView(),
    MyReviewsView(),
    ProfileScreen(),
  ];

  void _onNavBarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
