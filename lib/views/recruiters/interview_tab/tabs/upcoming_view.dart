import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/upcoming_interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/title_row.dart';
import 'package:provider/provider.dart';

class UpcomingView extends StatefulWidget {
  UpcomingView({super.key});

  @override
  State<UpcomingView> createState() => _UpcomingViewState();
}

class _UpcomingViewState extends State<UpcomingView> {
  late InterviewProvider _interviewProvider;
  List<InterviewEvent> interviewees = [];

  @override
  void initState() {
    super.initState();
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);

    fetchUpcomingInterview();
  }

  void fetchUpcomingInterview() async {
    await _interviewProvider.fetchUpcomingInterviews();
    setState(() {
      interviewees = _interviewProvider.upcomingInterviewList;
    });

    debugPrint("Fetching the upcoming interview successfully");
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay timeOfDay) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime theDayAfterTomorrow = DateTime.now().add(const Duration(days: 2));

    // Filter only the interviews for tomorrow
    List<InterviewEvent> tomorrowInterviews = interviewees.where((interviewee) {
      DateTime interviewStart =
          combineDateAndTime(interviewee.date!, interviewee.startTime!);
      return interviewStart.year == tomorrow.year &&
          interviewStart.month == tomorrow.month &&
          interviewStart.day == tomorrow.day;
    }).toList();

    // Filter only the interviews for the day after tomorrow
    List<InterviewEvent> dayAfterTomorrowInterviews =
        interviewees.where((interviewee) {
      DateTime interviewStart =
          combineDateAndTime(interviewee.date!, interviewee.startTime!);
      return interviewStart.year == theDayAfterTomorrow.year &&
          interviewStart.month == theDayAfterTomorrow.month &&
          interviewStart.day == theDayAfterTomorrow.day;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (tomorrowInterviews.isNotEmpty) ...[
            TitleRow(
              date: tomorrow,
              title: 'TOMORROW',
              color: const Color(0xff3e79f8),
            ),
            const Gap(20),
            ListView.builder(
              shrinkWrap:
                  true, // Ensures the ListView takes only as much space as needed
              physics:
                  const NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: tomorrowInterviews.length,
              itemBuilder: (context, index) {
                final interviewee = tomorrowInterviews[index];
                return UpcomingInterviewRowCard(
                  interview: interviewee,
                );
              },
            ),
          ],
          if (dayAfterTomorrowInterviews.isNotEmpty) ...[
            const Gap(30),
            TitleRow(
              date: theDayAfterTomorrow,
              title: '',
              color: const Color(0xff8E8E8E),
            ),
            const Gap(20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayAfterTomorrowInterviews.length,
              itemBuilder: (context, index) {
                final interviewee = dayAfterTomorrowInterviews[index];
                return UpcomingInterviewRowCard(
                  interview: interviewee,
                );
              },
            ),
          ],
          if (tomorrowInterviews.isEmpty && dayAfterTomorrowInterviews.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/empty_box.png",
                  width: 140,
                ),
                const Gap(20),
                const Text(
                  "You don't have any upcoming interviews.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
