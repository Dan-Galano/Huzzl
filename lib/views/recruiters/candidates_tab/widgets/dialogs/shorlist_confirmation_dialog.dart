import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:provider/provider.dart';

void showShortlistConfirmationDialog(BuildContext context, String jobPostId,
    String candidateId, String jobApplicationDocId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
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
                    "Confirm Shortlist",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Are you sure you want to move this applicant to the shortlisted candidates?",
                    style: TextStyle(fontSize: 16),
                  ),
                  Gap(8),
                  Text(
                    "You can move the applicant back to 'For Review' later if needed.",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
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
                          backgroundColor:
                              const Color.fromARGB(255, 180, 180, 180),
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
                          jobCandidateProvider.shortlistCandidate(
                              jobPostId, candidateId, jobApplicationDocId);

                          jobCandidateProvider.pushNotificationToJobseeker(
                            jobPostId,
                            candidateId,
                            "You have been Shortlisted",
                            "We are pleased to inform you that your application for the position has been shortlisted. Your qualifications and experience align well with what we are looking for, and we are excited to move forward with your application. Our team will be in touch soon with the next steps in the selection process. Thank you for your interest in joining our company, and we wish you the best of luck",
                          );

                          jobCandidateProvider.sendEmailNotification(
                              jobPostId, candidateId, "Shortlisted");

                          jobCandidateProvider.activityLogs(
                              action: "Shortlisted a applicant",
                              message: "Successfully shortlisted applicant.");

                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Shortlist',
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
