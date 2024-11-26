import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/candidates_widgets.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/contacted.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/filterrow.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/for_review.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/hired.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/rejected.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/reserved.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/shortlisted.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:provider/provider.dart';

class BuildCandidatesContent extends StatefulWidget {
  final VoidCallback onBack;
  final String jobPostId;
  final String jobTitle;
  final List<Candidate> candidates;
  final int initialIndex;

  const BuildCandidatesContent({
    required this.onBack,
    required this.jobPostId,
    required this.jobTitle,
    required this.candidates,
    required this.initialIndex,
    super.key,
  });

  @override
  State<BuildCandidatesContent> createState() => _BuildCandidatesContentState();
}

class _BuildCandidatesContentState extends State<BuildCandidatesContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late JobProviderCandidate _jobProvider;

  @override
  void initState() {
    super.initState();
    _jobProvider = Provider.of<JobProviderCandidate>(context, listen: false);
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    fetch();
  }

  void fetch() async {
    await _jobProvider.fetchCandidate(widget.jobPostId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: widget.onBack,
                  label: const Text(
                    "Back",
                    style: TextStyle(
                        color: Color(0xFFff9800), fontFamily: 'Galano'),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFff9800),
                  ),
                ),
                const Gap(20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double textFieldWidth = screenWidth * 0.7;
                    double spacing = screenWidth > 600 ? 20 : 10;

                    return Row(
                      children: [
                        SizedBox(width: spacing),
                        Text(
                          '${widget.jobTitle} Candidates',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 32,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: spacing),
                      ],
                    );
                  },
                ),
                const Gap(10),
                FilterRowWidget(),
                CustomTabBar(
                  tabController: _tabController,
                  candidates: widget.candidates,
                  jobPostId: widget.jobPostId,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ForReviewView(
                        candidates: widget.candidates
                            .where((candidate) =>
                                candidate.status == "For Review" &&
                                candidate.jobPostId == widget.jobPostId)
                            .toList(),
                      ),
                      ShortlistedView(
                        candidates: widget.candidates
                            .where((candidate) =>
                                candidate.status == "Shortlisted" &&
                                candidate.jobPostId == widget.jobPostId)
                            .toList(),
                      ),
                      ContactedView(
                        candidates: widget.candidates
                            .where((candidate) =>
                                candidate.status == "Contacted" &&
                                candidate.jobPostId == widget.jobPostId)
                            .toList(),
                      ),
                      RejectedView(
                        candidates: widget.candidates
                            .where((candidate) =>
                                candidate.status == "Rejected" &&
                                candidate.jobPostId == widget.jobPostId)
                            .toList(),
                      ),
                      HiredView(
                        candidates: widget.candidates
                            .where((candidate) =>
                                candidate.status == "Hired" &&
                                candidate.jobPostId == widget.jobPostId)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


// Widget BuildCandidatesContent(
//   BuildContext context,
//   VoidCallback onBack,
//   String jobPostId,
//   String jobTitle,
//   List<Candidate> candidates,
//   int initialIndex,
// ) {
//   var jobProvider = Provider.of<JobProviderCandidate>(context);
//   jobProvider.fetchCandidate(jobPostId);
//   return StatefulBuilder(
//     builder: (context, setState) {
//       TabController _tabController = TabController(
//         length: 5,
//         vsync: Scaffold.of(context),
//         initialIndex: initialIndex,
//       );

//       print("CANDIDATE SCREEN $jobTitle JOB ID: $jobPostId");

//       return Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextButton.icon(
//                     onPressed: onBack,
//                     label: const Text(
//                       "Back",
//                       style: TextStyle(
//                           color: Color(0xFFff9800), fontFamily: 'Galano'),
//                     ),
//                     icon: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       color: Color(0xFFff9800),
//                     ),
//                   ),
//                   const Gap(20),
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       double screenWidth = constraints.maxWidth;
//                       double textFieldWidth = screenWidth * 0.7;
//                       double spacing = screenWidth > 600 ? 20 : 10;

//                       return Row(
//                         children: [
//                           SizedBox(width: spacing),
//                           Text(
//                             '$jobTitle Candidates',
//                             style: const TextStyle(
//                               decoration: TextDecoration.none,
//                               fontSize: 32,
//                               color: Color(0xff373030),
//                               fontFamily: 'Galano',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           SizedBox(width: spacing),
//                           // SizedBox(
//                           //   width: textFieldWidth,
//                           //   child: TextField(
//                           //     decoration: searchTextFieldDecoration('Search'),
//                           //   ),
//                           // ),
//                         ],
//                       );
//                     },
//                   ),
//                   const Gap(10),
//                   FilterRowWidget(),
//                   CustomTabBar(
//                     tabController: _tabController,
//                     candidates: candidates,
//                     jobPostId: jobPostId,
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         ForReviewView(
//                             candidates: candidates
//                                 .where((candidate) =>
//                                     candidate.status == "For Review" &&
//                                     candidate.jobPostId == jobPostId)
//                                 .toList()),
//                         ShortlistedView(
//                             candidates: candidates
//                                 .where((candidate) =>
//                                     candidate.status == "Shortlisted" &&
//                                     candidate.jobPostId == jobPostId)
//                                 .toList()),
//                         ContactedView(
//                             candidates: candidates
//                                 .where((candidate) =>
//                                     candidate.status == "Contacted" &&
//                                     candidate.jobPostId == jobPostId)
//                                 .toList()),
//                         RejectedView(
//                             candidates: candidates
//                                 .where((candidate) =>
//                                     candidate.status == "Rejected" &&
//                                     candidate.jobPostId == jobPostId)
//                                 .toList()),
//                         HiredView(
//                             candidates: candidates
//                                 .where((candidate) =>
//                                     candidate.status == "Hired" &&
//                                     candidate.jobPostId == jobPostId)
//                                 .toList()),
//                         // ReservedView(),
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
