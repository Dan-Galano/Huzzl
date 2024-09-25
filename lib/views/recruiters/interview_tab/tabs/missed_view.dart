import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MissedView extends StatelessWidget {
  MissedView({super.key});
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
    }
  ];
  @override
  Widget build(BuildContext context) {
    if (interviewees.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(flex: 3, child: Text('')),
                SizedBox(
                  child: Text(
                    "Title",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Text('')),
                SizedBox(
                  width: 170,
                  child: Text(
                    "Interview Date",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Text('')),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: interviewees.length,
              itemBuilder: (context, index) {
                // return PastInterviewTileCard(
                //   intervieweeName: interviewees[index]['name'],
                //   interviewTitle: interviewees[index]['interviewTitle'],
                //   profession: interviewees[index]['profession'],
                //   branch: interviewees[index]['branch'],
                //   dateInterviewed: interviewees[index]['dateInterviewed'],
                // );
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
            "You don't have any missed interviews.",
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
