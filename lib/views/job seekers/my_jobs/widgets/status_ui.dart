import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/applied_jobs.dart';

class StatusUi extends StatelessWidget {
  final AppliedJobs myAppliedJob;

  const StatusUi({required this.myAppliedJob, super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors for each status
    final Map<String, Color> statusColors = {
      'For Review': Colors.orange.shade100,
      'Shortlisted': Colors.grey.shade300,
      'Rejected': Colors.red.shade100,
      'For Interview': Colors.blue.shade100,
      'Hired': Colors.green.shade100,
    };

    final Map<String, Color> textColors = {
      'For Review': Colors.orange.shade700,
      'Shortlisted': Colors.grey.shade700,
      'Rejected': Colors.red.shade700,
      'For Interview': Colors.blue.shade700,
      'Hired': Colors.green.shade700,
    };

    // Default colors if status is not in the map
    final backgroundColor = statusColors[myAppliedJob.status] ?? Colors.grey.shade200;
    final textColor = textColors[myAppliedJob.status] ?? Colors.grey.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Text(
        myAppliedJob.status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
