import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/open_job_card.dart';
import 'package:intl/intl.dart';

class OpenJobs extends StatefulWidget {
  final User user;
  final List<Candidate> candidates;
  const OpenJobs({required this.user, required this.candidates});

  @override
  State<OpenJobs> createState() => _OpenJobsState();
}

class _OpenJobsState extends State<OpenJobs> {
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.user.uid)
                .collection('job_posts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Handle the real-time update of job posts
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  // No job posts, show the empty message
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/empty_box.png",
                        width: 140,
                      ),
                      const Gap(20),
                      const Text(
                        "You have not posted any jobs yet.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Job posts are available, show the job posts
                  final jobPostsData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  final openJobs = jobPostsData
                      .where(
                        (jobPost) => jobPost.containsValue('open'),
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: openJobs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> jobPostIndividualData =
                          openJobs[index];
                      final DocumentSnapshot jobPostDoc =
                          snapshot.data!.docs[index];
                      final String jobPostId = jobPostDoc.id; // Job Post ID
                      //Display only open jobs
                      final int numberOfApplicants = widget.candidates 
                          .where(
                            (candidate) => candidate.jobPostId == jobPostId,
                          )
                          .toList()
                          .length;

                      return GestureDetector(
                        onTap: () {
                          final homeState = context.findAncestorStateOfType<
                              RecruiterHomeScreenState>();
                          homeState?.toggleCandidatesScreen(
                            true,
                            jobPostId,
                            jobPostIndividualData["jobTitle"],
                            0,
                          );
                          // print(jobPostId);
                        },
                        child: OpenJobCard(
                          jobTitle: jobPostIndividualData["jobTitle"],
                          jobType: jobPostIndividualData['jobType'],
                          jobDeadline:
                              jobPostIndividualData['applicationDeadline'],
                          jobPostedAt: jobPostIndividualData['posted_at'],
                          jobPostedBy: jobPostIndividualData['posted_by'],
                          numberOfApplicants: numberOfApplicants,
                        ),
                      );
                    },
                  );
                }
              } else {
                // Show a loading spinner or a fallback UI while fetching data
                return Center(child: CircularProgressIndicator());
              }
            },
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

Text textLists(String text) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'Galano',
      fontSize: 12,
    ),
  );
}
