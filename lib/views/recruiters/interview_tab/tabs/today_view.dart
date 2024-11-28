import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/title_row.dart';
import 'package:provider/provider.dart';

class TodayView extends StatefulWidget {
  TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  late InterviewProvider _interviewProvider;
  List<InterviewEvent> interviewees = [];

  @override
  void initState() {
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);

    fetchTodaysInterview();
    super.initState();
  }

  void fetchTodaysInterview() async{
    await _interviewProvider.fetchTodaysInterview();
    setState(() {
      interviewees = _interviewProvider.todaysInterviewList;
    });

    debugPrint("Fetching the todays interview successfully");
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    // // Filter only the interviews for today
    // List todayInterviews = interviewees.where((interviewee) {
    //   DateTime interviewStart = interviewee['timeRange'].start;
    //   return interviewStart.year == today.year &&
    //       interviewStart.month == today.month &&
    //       interviewStart.day == today.day;
    // }).toList();

    debugPrint("Details: ${interviewees.length}");

    if (interviewees.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TitleRow(
              date: today,
              title: 'TODAY',
              color: const Color(0xffFD7206),
            ),
            const Gap(20),
            ListView.builder(
              shrinkWrap: true, // Ensures ListView takes only needed space
              physics:
                  const NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: interviewees.length,
              itemBuilder: (context, index) {
                final interviewee = interviewees[index];
                return InterviewRowCard(
                  interview: interviewee,
                );
              },
            ),
          ],
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
            "You don't have any interviews today.",
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
