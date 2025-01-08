import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/closed.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/open.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/paused.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/jobfilterrow.dart';
import 'package:huzzl_web/views/recruiters/subscription/basic_plus.dart';
import 'package:intl/intl.dart';

class JobTab extends StatefulWidget {
  final VoidCallback postJob;
  final List<Candidate> candidates;
  final List<Map<String, dynamic>> jobPostsData;
  final User user;
  final int initialIndex;
  final Map<String, dynamic> userData;
  final String companyStatus;
  const JobTab({
    super.key,
    required this.candidates,
    required this.postJob,
    required this.jobPostsData,
    required this.user,
    required this.initialIndex,
    required this.userData,
    required this.companyStatus,
  });

  @override
  State<JobTab> createState() => _JobTabState();
}

class _JobTabState extends State<JobTab> {
  int _openJobsCount = 0;
  int _pausedJobsCount = 0;
  int _closedJobsCount = 0;

  @override
  void initState() {
    super.initState();
    _countJobPosts();
  }

  Future<void> _countJobPosts() async {
    try {
      QuerySnapshot jobPostsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('job_posts')
          .get();

      final jobPostsData = jobPostsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Get the current date
      final currentDate = DateTime.now();
      final DateFormat formatter = DateFormat('MMM d, yyyy'); // Date format

      // Separate jobs based on their status and deadline
      final openJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'open' &&
              deadlineDate.isAfter(currentDate);
        } catch (e) {
          print("Error parsing date for openJobs: $e");
          return false; // Exclude jobs with invalid or missing dates
        }
      }).toList();

      final pausedJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'paused' &&
              deadlineDate.isAfter(currentDate);
        } catch (e) {
          print("Error parsing date for pausedJobs: $e");
          return false; // Exclude jobs with invalid or missing dates
        }
      }).toList();

      final closedJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'closed' ||
              deadlineDate.isBefore(currentDate);
        } catch (e) {
          print("Error parsing date for closedJobs: $e");
          return true; // Count jobs with invalid or missing dates as closed
        }
      }).toList();

      // Update the counts in the state
      setState(() {
        _openJobsCount = openJobs.length;
        _pausedJobsCount = pausedJobs.length;
        _closedJobsCount = closedJobs.length;
      });
    } catch (e) {
      print("Error fetching job count: $e");
    }
  }

  void pendingModal() {
    showDialog(
      context: context,
      builder: (context) {
        // Show the modal dialog
        return const SizedBox(
          width: 200,
          child: AlertDialog(
            content: Padding(
              padding: EdgeInsets.all(50.0),
              child: Row(
                children: [
                  Text(
                    "Please wait for the approval of your business documents",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Add a 2-second delay before closing the dialog
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        TabController _tabController = TabController(
            length: 3,
            vsync: Scaffold.of(context),
            initialIndex: widget.initialIndex);

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double textFieldWidth = screenWidth * 0.7;
                        double spacing = screenWidth > 600 ? 20 : 10;

                        return Row(
                          children: [
                            const SizedBox(width: 20),
                            const Text(
                              'Jobs',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 32,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.5,
                            //   child: TextField(
                            //     decoration: searchTextFieldDecoration('Search'),
                            //   ),
                            // ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // widget.postJob
                                if (widget.companyStatus == "pending") {
                                  debugPrint(
                                      "Company status: ${widget.companyStatus}");
                                  pendingModal();
                                  // Navigator.pop(context);
                                  return;
                                }
                                final subscriptionType =
                                    widget.userData['subscriptionType'];
                                final jobPostsCount =
                                    widget.userData['jobPostsCount'] ?? 0;

                                debugPrint(
                                    "$subscriptionType ${jobPostsCount.toString()}");

                                if (subscriptionType == 'basic' &&
                                    jobPostsCount >= 2) {
                                  // Show a message if the limit is reached for basic subscription
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return MembershipPlansPage();
                                    },
                                  ));
                                } else {
                                  // Allow submission for Premium or Basic with available slots
                                  // _submitJobPost();
                                  widget.postJob();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0038FF),
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Post a new job',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                          ],
                        );
                      },
                    ),
                    // JobFilterRowWidget(),
                    TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.orange,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Galano',
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Galano',
                      ),
                      tabs: [
                        Tab(text: '$_openJobsCount Open'),
                        Tab(text: '$_pausedJobsCount Paused'),
                        Tab(text: '$_closedJobsCount Closed'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OpenJobs(
                            // jobPostsData: widget.jobPostsData,
                            user: widget.user,
                            candidates: widget.candidates,
                          ),
                          PausedJobs(
                            user: widget.user,
                            candidates: widget.candidates,
                          ),
                          ClosedJobs(
                            user: widget.user,
                            candidates: widget.candidates,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
