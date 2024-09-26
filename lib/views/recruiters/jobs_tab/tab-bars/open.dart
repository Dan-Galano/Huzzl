import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/open_job_card.dart';
import 'package:intl/intl.dart';

class OpenJobs extends StatefulWidget {
  final List<Map<String, dynamic>> jobPostsData;
  final User user;
  const OpenJobs({required this.jobPostsData, required this.user});

  @override
  State<OpenJobs> createState() => _OpenJobsState();
}

class _OpenJobsState extends State<OpenJobs> {
  bool isJobPostEmpty = true;

  @override
  Widget build(BuildContext context) {
    if (widget.jobPostsData.isNotEmpty) {
      setState(() {
        isJobPostEmpty = false;
      });
    }
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
        !isJobPostEmpty
            ? Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.uid)
                      .collection('job_posts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Show a loading spinner while waiting for data
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}')); // Handle errors
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child:
                              Text('No Job Posts Found')); // Handle empty state
                    }

                    // Extract the data from the snapshot
                    final jobPostsData = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    return ListView.builder(
                      itemCount: jobPostsData.length,
                      itemBuilder: (context, index) {
                        // Specific data for the job post
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
                  },
                ),
              )
            : Column(
                children: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("No job post yet."),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                ],
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
