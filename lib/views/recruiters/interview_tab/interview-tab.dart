import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/missed_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/past_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/pending_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/reschedule_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/today_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/upcoming_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/interviews_widgets.dart';

Widget buildInterviewsContent() {
  return StatefulBuilder(
    builder: (context, setState) {
      TabController _tabController =
          TabController(length: 6, vsync: Scaffold.of(context));
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double textFieldWidth = screenWidth * 0.7;
                double spacing = screenWidth > 600 ? 20 : 10;

                return Row(
                  children: [
                    SizedBox(width: spacing),
                    const Text(
                      'Interviews',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: spacing),
                    SizedBox(
                      width: textFieldWidth,
                      child: TextField(
                        decoration: searchTextFieldDecoration('Search'),
                      ),
                    ),
                  ],
                );
              },
            ),
            InterviewFilterRowWidget(),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              labelStyle: const TextStyle(
                fontSize: 18, // Font size of the selected tab
                fontWeight: FontWeight.bold, // Font weight of the selected tab
                fontFamily: 'Galano', // Use your custom font
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16, // Font size of the unselected tabs
                fontWeight:
                    FontWeight.normal, // Font weight of the unselected tabs
                fontFamily: 'Galano', // Use your custom font
              ),
              tabs: const [
                Tab(text: '2 Today'),
                Tab(text: '0 Upcoming'),
                Tab(text: '0 Pending'),
                Tab(text: '0 Past'),
                Tab(text: '0 Rescheduled'),
                Tab(text: '0 Missed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Active Tab Content
                  TodayView(),
                  // Archive Tab Content
                  UpcomingView(),
                  PendingView(),
                  PastView(),
                  RescheduleView(),
                  MissedView(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
