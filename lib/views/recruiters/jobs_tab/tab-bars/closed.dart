import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/closed_job_card.dart';

class ClosedJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              headersList("Job Type"),
              headersList("Posted by"),
              headersList("Total applicants"),
              headersList("Date closed"),
              Gap(50),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ClosedJobCard(),
            ],
          ),
        ),
      ],
    );
  }

  Padding headersList(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xff3B7DFF),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}
