import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/open_job_card.dart';

class OpenJobs extends StatelessWidget {
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
              headersList("Type"),
              headersList("Posted by"),
              headersList("Status"),
              headersList("Date posted"),
              headersList("Deadline"),
              Gap(50),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              OpenJobCard(),
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
