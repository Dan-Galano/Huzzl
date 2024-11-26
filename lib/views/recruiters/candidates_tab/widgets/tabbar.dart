import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  List<Candidate> candidates;
  String jobPostId; 

  CustomTabBar(
      {super.key,
      required this.tabController,
      required this.candidates,
      required this.jobPostId});

  @override
  Widget build(BuildContext context) {
    int countForReview = candidates
        .where((candidate) =>
            candidate.status == "For Review" &&
            candidate.jobPostId == jobPostId)
        .length;
    int countForShortlisted = candidates
        .where((candidate) =>
            candidate.status == "Shortlisted" &&
            candidate.jobPostId == jobPostId)
        .length;
    int countForContacted = candidates
        .where((candidate) =>
            candidate.status == "Contacted" &&
            candidate.jobPostId == jobPostId)
        .length;
    int countForRejected = candidates
        .where((candidate) =>
            candidate.status == "Rejected" &&
            candidate.jobPostId == jobPostId)
        .length;
    int countForHired = candidates
        .where((candidate) =>
            candidate.status == "Hired" && candidate.jobPostId == jobPostId)
        .length;

    return TabBar(
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Galano',
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Galano',
      ),
      tabs: [
        Tab(text: '$countForReview For Review'),
        Tab(text: '$countForShortlisted Shortlisted'),
        Tab(text: '$countForContacted Contacted'),
        Tab(text: '$countForRejected Rejected'),
        Tab(text: '$countForHired Hired'),
        // Tab(text: '0 Reserved'),
      ],
    );
  }
}
