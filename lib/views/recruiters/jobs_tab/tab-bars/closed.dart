import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/closed_job_card.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ClosedJobs extends StatefulWidget {
  final User user;
  final List<Candidate> candidates;
  const ClosedJobs({super.key, required this.user, required this.candidates});

  @override
  State<ClosedJobs> createState() => _ClosedJobsState();
}

class _ClosedJobsState extends State<ClosedJobs> {
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
                headersList("Total applicants"),
                headersList("Date posted"),
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
                                color: Colors.grey[
                                    200], // Grey background for the shimmer
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

              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/empty_box.png",
                        width: 140,
                      ),
                      const Gap(20),
                      const Text(
                        "Job posts that have been closed will appear here.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Filter closed jobs
                  final jobPostsData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  // Current date and formatter for deadline comparison
                  final currentDate = DateTime.now();
                  final DateFormat formatter = DateFormat('MMM d, yyyy');

                  // Fetch jobs classified as closed
                  final closedJobs = jobPostsData.where((jobPost) {
                    final deadlineString = jobPost['applicationDeadline'];
                    try {
                      final deadlineDate = formatter.parse(deadlineString);
                      return jobPost['status'] == 'closed' ||
                          deadlineDate.isBefore(currentDate);
                    } catch (e) {
                      print("Error parsing date for closedJobs: $e");
                      return true; // Include jobs with invalid or missing deadlines as closed
                    }
                  }).toList();

                  if (closedJobs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/empty_box.png",
                          width: 140,
                        ),
                        const Gap(20),
                        const Text(
                          "Job posts that have been closed will appear here.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: closedJobs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> jobPostIndividualData =
                            closedJobs[index];
                        final DocumentSnapshot jobPostDoc =
                            snapshot.data!.docs[index];
                        final String jobPostId = jobPostDoc.id; // Job Post ID

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
                            // Add logic for tap action if needed
                          },
                          child: ClosedJobCard(
                            jobTitle: jobPostIndividualData["jobTitle"],
                            jobType: jobPostIndividualData['jobType'],
                            jobDeadline:
                                jobPostIndividualData['applicationDeadline'],
                            jobPostedAt: jobPostIndividualData['posted_at'],
                            jobPostID: jobPostIndividualData['jobPostID'],
                            jobPostedBy: jobPostIndividualData['posted_by'],
                            numberOfApplicants: numberOfApplicants,
                            user: widget.user,
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
                                color: Colors.grey[
                                    200], // Grey background for the shimmer
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
