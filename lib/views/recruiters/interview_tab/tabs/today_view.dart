import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/title_row.dart';

class TodayView extends StatelessWidget {
  TodayView({super.key});

  final List interviewees = [
    {
      'name': 'Elijah Japheth Macatiag',
      'profession': 'Photographer',
      'branch': 'Urdaneta City',
      'interviewTitle': 'Technical Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'A Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      ),
    },
    {
      'name': 'S Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      ),
    },
    {
      'name': 'xz Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      ),
    },
    {
      'name': 's Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Face-to-face',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      ),
    },
    {
      'name': 'd Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 10, 0),
        end: DateTime(2024, 9, 25, 12, 0),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    // Filter only the interviews for today
    List todayInterviews = interviewees.where((interviewee) {
      DateTime interviewStart = interviewee['timeRange'].start;
      return interviewStart.year == today.year &&
          interviewStart.month == today.month &&
          interviewStart.day == today.day;
    }).toList();

    if (todayInterviews.isNotEmpty) {
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
              itemCount: todayInterviews.length,
              itemBuilder: (context, index) {
                final interviewee = todayInterviews[index];
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
