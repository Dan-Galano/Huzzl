import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/pending_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:provider/provider.dart';

class PendingView extends StatefulWidget {
  PendingView({super.key});

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  late InterviewProvider _interviewProvider;

  List<Candidate> candidatesShortlisted = [];

  @override
  void initState() {
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);

    fetchShortlistedCandidate();
    super.initState();
  }

  void fetchShortlistedCandidate() async {
    await _interviewProvider.fetchShortlistedCandidateToDisplayInPendingTab();
    setState(() {
      candidatesShortlisted =
          _interviewProvider.shortListedCandidateDisplayInPending;
    });

    debugPrint("Fetched successfully shortlisted candidate");
  }

  @override
  Widget build(BuildContext context) {
    if (candidatesShortlisted.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: candidatesShortlisted.length,
          itemBuilder: (context, index) {
            return PendingTileCard(
              candidate: candidatesShortlisted[index],
              // intervieweeName: candidatesShortlisted[index].name,
              // profession: candidatesShortlisted[index].profession,
              // // branch: candidatesShortlisted[index]['branch'],
              // shortlistDate: candidatesShortlisted[index].applicationDate,
            );
          },
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 140,
          ),
          const Gap(20),
          const Text(
            "You don't have any pending interviews.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }
}
