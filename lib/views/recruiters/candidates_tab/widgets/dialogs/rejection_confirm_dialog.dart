import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:provider/provider.dart';

void showRejectConfirmationDialog(BuildContext context, String jobPostId, String candidateId, String jobApplicationDocId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
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
                "Confirm Applicant Rejection",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(10),
              Text(
                "Are you sure you want to reject this applicant?",
                style: TextStyle(fontSize: 16),
              ),
              Gap(8),
              Text(
                "This action cannot be undone.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
                      jobCandidateProvider.rejectCandidate(jobPostId, candidateId, jobApplicationDocId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      backgroundColor: const Color(0xFFd74a4a),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject',
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
}
