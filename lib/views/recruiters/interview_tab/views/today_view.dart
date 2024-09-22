import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/interview_row_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/interview_tile_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/title_row.dart';

class TodayView extends StatelessWidget {
  TodayView({super.key});

  List interviewees = [];

  @override
  Widget build(BuildContext context) {
    if (interviewees.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TitleRow(
              date: DateTime.now(),
              title: 'TODAY',
            ),
            const Gap(20),
            Expanded(
                child: ListView(
              children: [
                InterviewRowCard(
                  intervieweeName: 'Elijah Japheth Macatiag',
                  profession: 'Photographer',
                  branch: 'Urdaneta City',
                  interviewTitle: 'Technical Interview',
                  interviewType: 'Online',
                  timeRange: DateTimeRange(
                      start: DateTime(2024, 9, 1, 8, 0),
                      end: DateTime(2024, 9, 1, 10, 0)),
                ),
                InterviewRowCard(
                  intervieweeName: 'Jau Salcedo',
                  profession: 'Web Developer',
                  branch: 'Alaminos City',
                  interviewTitle: 'Final Interview',
                  interviewType: 'Face-to-face',
                  timeRange: DateTimeRange(
                      start: DateTime(2024, 9, 1, 10, 0),
                      end: DateTime(2024, 9, 1, 12, 0)),
                ),
              ],
            )),
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
