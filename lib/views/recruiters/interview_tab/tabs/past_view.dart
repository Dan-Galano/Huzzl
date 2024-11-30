import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/past_interview_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:provider/provider.dart';

class PastView extends StatefulWidget {
  PastView({super.key});

  @override
  State<PastView> createState() => _PastViewState();
}

class _PastViewState extends State<PastView> {
  late InterviewProvider _interviewProvider;

  List<InterviewEvent> interviewees = [];

  @override
  void initState() {
    super.initState();
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);

    fetchPastInterview();
  }

  void fetchPastInterview() async {
    await _interviewProvider.fetchPastInterviews();
    setState(() {
      interviewees = _interviewProvider.pastInterviews;
    });

    debugPrint("Fetching the past interview successfully");
  }

  @override
  Widget build(BuildContext context) {
    if (interviewees.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: interviewees.length,
          itemBuilder: (context, index) {
            return PastInterviewTileCard(
              interview: interviewees[index],
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
            "You don't have any past interviews.",
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
