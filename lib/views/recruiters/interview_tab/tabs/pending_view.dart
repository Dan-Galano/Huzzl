import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/pending_card.dart';

class PendingView extends StatelessWidget {
  PendingView({super.key});

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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
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
    },
    {
      'name': 'Jau Macatiag',
      'profession': 'Photographer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'shortlistDate': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (interviewees.isNotEmpty) {
      return Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  "Shortlist Date",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              Gap(470)
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: interviewees.length,
              itemBuilder: (context, index) {
                return PendingTileCard(
                  intervieweeName: interviewees[index]['name'],
                  profession: interviewees[index]['profession'],
                  branch: interviewees[index]['branch'],
                  shortlistDate: interviewees[index]['shortlistDate'],
                );
              },
            ),
          ),
        ],
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
