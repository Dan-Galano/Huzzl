import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/open_job_card.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
        const Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                headersList("Job type"),
                headersList("Posted by"),
                headersList("Status"),
                headersList("Date posted"),
                headersList("Deadline"),
                const Gap(65),
              ],
            ),
          ],
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
 return Column(
        children: [
          const Gap(30),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Show 5 shimmer loading items
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200], // Grey background for the shimmer
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 110, // Height of each placeholder card
                  ),
                );
              },
            ),
          ),
        ],
      );
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
                        "All currently open job posts will appear here.",
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

                  //Display only open jobs
                  final openJobs = jobPostsData
                      .where(
                        (jobPost) => jobPost.containsValue('open'),
                      )
                      .toList();

                  if (openJobs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/empty_box.png",
                          width: 140,
                        ),
                        const Gap(20),
                        const Text(
                          "All currently open job posts will appear here.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: openJobs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> jobPostIndividualData =
                            openJobs[index];
                        final DocumentSnapshot jobPostDoc =
                            snapshot.data!.docs[index];
                        final String jobPostId = jobPostDoc.id; // Job Post ID
                        //Cinocompare dito if yung jobPostId ni candidate is same sa id na clinick ni user na job post
                        final int numberOfApplicants = widget.candidates
                            .where(
                              (candidate) =>
                                  candidate.jobPostId ==
                                  jobPostIndividualData['jobPostID'],
                            )
                            .toList()
                            .length;
                        return GestureDetector(
                          onTap: () {
                            print(
                                "TAPPED BOSS: ${jobPostIndividualData['jobPostID']} ${jobPostIndividualData['jobTitle']}");
                            final homeState = context.findAncestorStateOfType<
                                RecruiterHomeScreenState>();
                            homeState?.toggleCandidatesScreen(
                              true,
                              jobPostIndividualData['jobPostID'],
                              jobPostIndividualData["jobTitle"],
                              0,
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
                }
              } else {
                // Show a loading spinner or a fallback UI while fetching data
                return Column(
        children: [
          const Gap(30),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Show 5 shimmer loading items
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200], // Grey background for the shimmer
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 110, // Height of each placeholder card
                  ),
                );
              },
            ),
          ),
        ],
      );
      }
            },
          ),
        ),
      ],
    );
  }

  SizedBox headersList(String text) {
    return SizedBox(
      width: 160,
      // color: Colors.amberAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff3B7DFF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
