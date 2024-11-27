import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/calendar.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/missed_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/past_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/pending_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/rescheduled_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/today_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/tabs/upcoming_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/buttons.dart';
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        decoration: searchTextFieldDecoration('Search'),
                      ),
                    ),
                  ],
                );
              },
            ),
            // InterviewFilterRowWidget(),
            TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              labelStyle: const TextStyle(
                fontSize: 14, // Font size of the selected tab
                fontWeight: FontWeight.bold, // Font weight of the selected tab
                fontFamily: 'Galano', // Use your custom font
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12, // Font size of the unselected tabs
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
                  RescheduledView(),
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
