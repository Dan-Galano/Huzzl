import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/title_row.dart';

class UpcomingView extends StatelessWidget {
  UpcomingView({super.key});

  final List interviewees = [
    {
      'name': 'Cedric Joel Cayaban',
      'profession': 'Photographer',
      'branch': 'Mangaterem',
      'interviewTitle': 'Technical Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 26, 8, 0),
        end: DateTime(2024, 9, 26, 10, 0),
      )
    },
    {
      'name': 'Justin Carpio',
      'profession': 'Web Developer',
      'branch': 'Mangaldan',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 26, 10, 0),
        end: DateTime(2024, 9, 26, 12, 0),
      )
    },
    {
      'name': 'Cedric Joel Cayaban',
      'profession': 'Photographer',
      'branch': 'Mangaterem',
      'interviewTitle': 'Technical Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 26, 8, 0),
        end: DateTime(2024, 9, 26, 10, 0),
      )
    },
    {
      'name': 'Justin Carpio',
      'profession': 'Web Developer',
      'branch': 'Mangaldan',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 26, 10, 0),
        end: DateTime(2024, 9, 26, 12, 0),
      )
    },
    {
      'name': 'Bob Carpio',
      'profession': 'Web Developer',
      'branch': 'Mangaldan',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 27, 10, 0),
        end: DateTime(2024, 9, 27, 12, 0),
      )
    },
    {
      'name': 'Bob Carpio',
      'profession': 'Web Developer',
      'branch': 'Mangaldan',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      )
    },
    {
      'name': 'Christopherson Carpio',
      'profession': 'Web Developer',
      'branch': 'Mangaldan',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 27, 10, 0),
        end: DateTime(2024, 9, 27, 12, 0),
      )
    }
  ];

  @override
  Widget build(BuildContext context) {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime theDayAfterTomorrow = DateTime.now().add(const Duration(days: 2));

    // Filter only the interviews for tomorrow
    List tomorrowInterviews = interviewees.where((interviewee) {
      DateTime interviewStart = interviewee['timeRange'].start;
      return interviewStart.year == tomorrow.year &&
          interviewStart.month == tomorrow.month &&
          interviewStart.day == tomorrow.day;
    }).toList();

    // Filter only the interviews for the day after tomorrow
    List dayAfterTomorrowInterviews = interviewees.where((interviewee) {
      DateTime interviewStart = interviewee['timeRange'].start;
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
                return InterviewRowCard(
                  intervieweeName: interviewee['name'],
                  profession: interviewee['profession'],
                  branch: interviewee['branch'],
                  interviewTitle: interviewee['interviewTitle'],
                  interviewType: interviewee['interviewType'],
                  timeRange: interviewee['timeRange'],
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
                return InterviewRowCard(
                  intervieweeName: interviewee['name'],
                  profession: interviewee['profession'],
                  branch: interviewee['branch'],
                  interviewTitle: interviewee['interviewTitle'],
                  interviewType: interviewee['interviewType'],
                  timeRange: interviewee['timeRange'],
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
