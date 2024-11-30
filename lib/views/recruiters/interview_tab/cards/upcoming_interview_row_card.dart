import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/interview_tile_card.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/cards/upcoming_tile_card.dart';
import 'package:intl/intl.dart';

class UpcomingInterviewRowCard extends StatelessWidget {
  const UpcomingInterviewRowCard({super.key, required this.interview});

  final InterviewEvent interview;

  // final String intervieweeName;
  // final String profession;
  // // final String branch;
  // final String interviewTitle;
  // final String interviewType;
  // final TimeOfDay startTime;
  // final TimeOfDay endTime;

  @override
  Widget build(BuildContext context) {
    // Create a DateFormat for 12-hour format with AM/PM
    final DateFormat timeFormat = DateFormat.jm();

    String formatTimeOfDay(TimeOfDay time) {
      final now = DateTime.now();
      final dateTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return DateFormat.jm().format(dateTime); // Format as '9:40 AM'
    }

    // Format the start and end times
    // String startTime = timeFormat.format(_parseTimeOfDay.start);
    // String endTime = timeFormat.format(_parseTimeOfDay.end);

    return Row(
      children: [
        Container(
          width: 260,
          // color: Colors.redAccent,
          child: Text(
            '${formatTimeOfDay(interview.startTime!)} - ${formatTimeOfDay(interview.endTime!)}',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: UpcomingInterviewTile(
            interview: interview,
          ),
        ),
      ],
    );
  }
}
