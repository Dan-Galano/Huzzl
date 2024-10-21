import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/open_job_card.dart';
import 'package:intl/intl.dart';

class OpenJobs extends StatefulWidget {
  final User user;
  const OpenJobs({required this.user});

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
                 return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.transparent,
              content: Container(
                width: 105,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Gap(10),
                      Image.asset(
                        'assets/images/huzzl_loading.gif',
                        height: 100,
                        width: 100,
                      ),
                      Gap(10),
                      Text(
                        "Loading...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFfd7206),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

                  return ListView.builder(
                    itemCount: jobPostsData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> jobPostIndividualData =
                          jobPostsData[index];

                      return OpenJobCard(
                        jobTitle: jobPostIndividualData["jobTitle"],
                        jobType: jobPostIndividualData['jobType'],
                        jobDeadline:
                            jobPostIndividualData['applicationDeadline'],
                        jobPostedAt: jobPostIndividualData['posted_at'],
                      );
                    },
                  );
                }
              } else {
                // Show a loading spinner or a fallback UI while fetching data
                 return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.transparent,
              content: Container(
                width: 105,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Gap(10),
                      Image.asset(
                        'assets/images/huzzl_loading.gif',
                        height: 100,
                        width: 100,
                      ),
                      Gap(10),
                      Text(
                        "Loading...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFfd7206),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      
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
