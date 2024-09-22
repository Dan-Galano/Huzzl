import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/candidates_widgets.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/contacted.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/filterrow.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/for_review.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/hired.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/rejected.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/reserved.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/shortlisted.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar.dart';

// Widget buildCandidatesContent(BuildContext context) {
//   return StatefulBuilder(
//     builder: (context, setState) {
//       TabController _tabController =
//           TabController(length: 6, vsync: Scaffold.of(context));

//       return Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       double screenWidth = constraints.maxWidth;
//                       double textFieldWidth = screenWidth * 0.7;
//                       double spacing = screenWidth > 600 ? 20 : 10;

//                       return Row(
//                         children: [
//                           SizedBox(width: spacing),
//                           const Text(
//                             'Candidates',
//                             style: TextStyle(
//                               decoration: TextDecoration.none,
//                               fontSize: 32,
//                               color: Color(0xff373030),
//                               fontFamily: 'Galano',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           SizedBox(width: spacing),
//                           SizedBox(
//                             width: textFieldWidth,
//                             child: TextField(
//                               decoration: searchTextFieldDecoration('Search'),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   Gap(10),
//                   FilterRowWidget(),
//                   TabBar(
//                     tabAlignment: TabAlignment.start,
//                     isScrollable: true,
//                     controller: _tabController,
//                     labelColor: Colors.black,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.orange,
//                     labelStyle: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Galano',
//                     ),
//                     unselectedLabelStyle: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: 'Galano',
//                     ),
//                     tabs: const [
//                       Tab(text: '4 For Review'),
//                       Tab(text: '0 Shortlisted'),
//                       Tab(text: '0 Contacted'),
//                       Tab(text: '0 Rejected'),
//                       Tab(text: '0 Hired'),
//                       Tab(text: '0 Reserved'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         ForReviewView(),
//                         ShortlistedView(),
//                         ContactedView(),
//                         RejectedView(),
//                         HiredView(),
//                         ReservedView(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

Widget buildCandidatesContent(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
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
                  Gap(10),
                  FilterRowWidget(),
                  CustomTabBar(tabController: _tabController),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ForReviewView(),
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
