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
  final currentDate = DateTime.now();

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
                .snapshots(), // Fetch all job posts
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
                  final currentDate = DateTime.now(); // Get the current date
                  final DateFormat formatter = DateFormat(
                      'MMM d, yyyy'); // Define the expected date format

                  // Parse and filter job posts based on the applicationDeadline and numberOfPeopleToHire
                  final jobPostsData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((jobPost) {
                    // Parse the deadline and get the job's current number of applicants
                    final deadlineString = jobPost['applicationDeadline'];
                    final int numberOfPeopleToHire =
                        int.parse(jobPost['numberOfPeopleToHire'] ?? 0);
                    final String jobPostID = jobPost['jobPostID'];
                    final String status = jobPost['status'] ?? 'open';

                    // Count the number of applicants for this job
                    final int numberOfApplicants = widget.candidates
                        .where((candidate) => candidate.jobPostId == jobPostID)
                        .length;

                    try {
                      final deadlineDate = formatter.parse(deadlineString);

                      // If job post reaches its hiring goal, update its status to 'close'
                      if (numberOfApplicants >= numberOfPeopleToHire &&
                          status != 'closed') {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.user.uid)
                            .collection('job_posts')
                            .doc(jobPostID)
                            .update({'status': 'closed'}).then((_) {
                          print('Job post $jobPostID status updated to close.');
                        }).catchError((error) {
                          print('Failed to update status: $error');
                        });
                        return false; // Exclude this job post since it's now closed
                      }

                      // Filter for jobs with a valid future deadline and not closed
                      return deadlineDate.isAfter(currentDate) &&
                          numberOfApplicants < numberOfPeopleToHire &&
                          status != 'closed';
                    } catch (e) {
                      print("Error parsing date: $e");
                      return false; // Exclude invalid dates
                    }
                  }).toList();

                  if (jobPostsData.isEmpty) {
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
                      itemCount: jobPostsData.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> jobPostIndividualData =
                            jobPostsData[index];
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
                          },
                          child: OpenJobCard(
                            jobTitle: jobPostIndividualData["jobTitle"],
                            jobType: jobPostIndividualData['jobType'],
                            jobDeadline:
                                jobPostIndividualData['applicationDeadline'],
                            jobPostedAt: jobPostIndividualData['posted_at'],
                            jobPostedBy: jobPostIndividualData['posted_by'],
                            jobPostID: jobPostIndividualData['jobPostID'],
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
