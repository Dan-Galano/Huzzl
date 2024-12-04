import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showHiringConfirmationDialog(BuildContext context, Candidate candidate,
    DateTime hiredDate, String generatedHiringMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm Applicant Hire",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Are you sure you want to hire this applicant?",
                    style: TextStyle(fontSize: 16),
                  ),
                  Gap(8),
                  Text(
                    "This action cannot be undone.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF157925),
                    ),
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          backgroundColor: Color.fromARGB(255, 180, 180, 180),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Gap(10),
                      TextButton(
                        onPressed: () {
                          jobCandidateProvider.hiringCandidate(
                              candidate.jobPostId,
                              candidate.id,
                              candidate.jobApplicationDocId!);
                          jobCandidateProvider.pushNotificationToJobseeker(
                            candidate.jobPostId,
                            candidate.id,
                            'You are Hired',
                            """
Starting Date: ${DateFormat('MMMM d, y').format(hiredDate)}

$generatedHiringMessage
""",
                          );

                          jobCandidateProvider.sendEmailNotification(
                              candidate.jobPostId, candidate.id, "Hired",
                              message: generatedHiringMessage);

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          backgroundColor: const Color(0xFF157925),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Hire',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
