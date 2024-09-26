import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/past_interview_card.dart';

class PastView extends StatelessWidget {
  PastView({super.key});

  final List interviewees = [
    {
      'name': 'Elijah Japheth Macatiag',
      'profession': 'Photographer',
      'branch': 'Urdaneta City',
      'interviewTitle': 'Technical Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Jau Salcedo',
      'profession': 'Web Developer',
      'branch': 'Alaminos City',
      'interviewTitle': 'Final Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
      'interviewType': 'Online',
      'timeRange': DateTimeRange(
        start: DateTime(2024, 9, 25, 8, 0),
        end: DateTime(2024, 9, 25, 10, 0),
      ),
    },
    {
      'name': 'Dan Galano',
      'profession': 'Web Developer',
      'branch': 'AlaminosSSSS City',
      'interviewTitle': 'Basta Interview',
      'dateInterviewed': DateTime(2024, 9, 25, 8, 30),
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Gap(350),
                    Row(
                      children: [
                        Text(
                          "Date Interviewed",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                    Gap(290),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: interviewees.length,
              itemBuilder: (context, index) {
                return PastInterviewTileCard(
                  intervieweeName: interviewees[index]['name'],
                  interviewTitle: interviewees[index]['interviewTitle'],
                  profession: interviewees[index]['profession'],
                  branch: interviewees[index]['branch'],
                  dateInterviewed: interviewees[index]['dateInterviewed'],
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
