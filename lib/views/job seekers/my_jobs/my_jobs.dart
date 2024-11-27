import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/applied_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/archived_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/interviews_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/saved_view.dart';

class MyJobsView extends StatefulWidget {
  const MyJobsView({super.key});

  @override
  State<MyJobsView> createState() => _MyJobsViewState();
}

class _MyJobsViewState extends State<MyJobsView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController =
          TabController(length: 4, vsync: this);

    return Scaffold(
       body: Column(
        children: [
          //==================================== Content ====================================
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            'My Jobs',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 32,
                              color: Color(0xff373030),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Gap(10),
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
                Tab(text: '2 Saved'),
                Tab(text: '0 Applied'),
                Tab(text: '0 Interviews'),
                Tab(text: '0 Archived'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Saved Tab Content
                  SavedView(),
                  // Applied Tab Content
                  AppliedView(),
                  // Interviews Tab Content
                  InterviewsView(),
                  // Archived Tab Content
                  ArchivedView(),
                ],
              ),
            ),
                ],
              ),
            ),
          ),
        ],
       ),
    );
  }
}
