import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_tile_card.dart';
import 'package:intl/intl.dart';

class InterviewRowCard extends StatelessWidget {
  const InterviewRowCard({
    super.key,
    required this.intervieweeName,
    required this.profession,
    required this.branch,
    required this.interviewTitle,
    required this.interviewType,
    required this.timeRange,
  });

  final String intervieweeName;
  final String profession;
  final String branch;
  final String interviewTitle;
  final String interviewType;
  final DateTimeRange timeRange;

  @override
  Widget build(BuildContext context) {
    // Create a DateFormat for 12-hour format with AM/PM
    final DateFormat timeFormat = DateFormat.jm();

    // Format the start and end times
    String startTime = timeFormat.format(timeRange.start);
    String endTime = timeFormat.format(timeRange.end);

    return Row(
      children: [
        Container(
          width: 260,
          // color: Colors.redAccent,
          child: Text(
            '$startTime - $endTime',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: InterviewTile(
            intervieweeName: intervieweeName,
            profession: profession,
            branch: branch,
            interviewTitle: interviewTitle,
            interviewType: interviewType,
            timeRange: timeRange,
          ),
        ),
      ],
    );
  }
}
