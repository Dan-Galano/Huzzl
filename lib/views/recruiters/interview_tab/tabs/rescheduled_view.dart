import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/rescheduled_interview_card.dart';

class RescheduledView extends StatelessWidget {
  RescheduledView({super.key});

  final List interviewees = [
    {
      'name': 'Elijah Japheth Macatiag',
      'profession': 'Photographer',
      'branch': 'Urdaneta City',
      'interviewTitle': 'Technical Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
      'formerDateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'newDateInterviewed': DateTime(2024, 9, 27, 8, 30),
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'ABC City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
      'formerDateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'newDateInterviewed': DateTime(2024, 9, 27, 8, 30),
    }
  ];

  @override
  Widget build(BuildContext context) {
    if (interviewees.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(''),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Title",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                      Gap(140),
                      Row(
                        children: [
                          Text(
                            "Former Interview Date",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                      Gap(140),
                      Row(
                        children: [
                          Text(
                            "New Interview Date",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                      Gap(190),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: interviewees.length,
              itemBuilder: (context, index) {
                return RescheduledInterviewTileCard(
                  intervieweeName: interviewees[index]['name'],
                  interviewTitle: interviewees[index]['interviewTitle'],
                  profession: interviewees[index]['profession'],
                  branch: interviewees[index]['branch'],
                  formerDateInterviewed: interviewees[index]
                      ['formerDateInterviewed'],
                  newDateInterviewed: interviewees[index]['newDateInterviewed'],
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
            "You don't have any rescheduled interviews.",
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
