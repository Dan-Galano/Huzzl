import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/candidates_widgets.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/contacted.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/filterrow.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/for_review.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/hired.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/rejected.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/reserved.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/shortlisted.dart';

Widget buildCandidatesContent(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      // Initialize the TabController inside the StatefulBuilder
      TabController _tabController =
          TabController(length: 6, vsync: Scaffold.of(context));

      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                            'Candidates',
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
                  // Add Tabs for Active and Archive
                  Gap(10),
                  FilterRowWidget(),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    labelStyle: const TextStyle(
                      fontSize: 18, // Font size of the selected tab
                      fontWeight:
                          FontWeight.bold, // Font weight of the selected tab
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16, // Font size of the unselected tabs
                      fontWeight: FontWeight
                          .normal, // Font weight of the unselected tabs
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    tabs: const [
                      Tab(text: '4 For Review'),
                      Tab(text: '0 Shortlisted'),
                      Tab(text: '0 Contacted'),
                      Tab(text: '0 Rejected'),
                      Tab(text: '0 Hired'),
                      Tab(text: '0 Reserved'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Active Tab Content
                        ForReviewView(),
                        // Archive Tab Content
                        ShortlistedView(),
                        ContactedView(),
                        RejectedView(),
                        HiredView(),
                        ReservedView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class Branch {
  final String name;
  final String manager;
  final String dateEstablished;

  Branch(
      {required this.name,
      required this.manager,
      required this.dateEstablished});
}

// Example Archive Branches List (if any)

// Branch List Tile widget
