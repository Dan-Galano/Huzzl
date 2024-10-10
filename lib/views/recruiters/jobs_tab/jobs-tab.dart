import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/closed.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/open.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/tab-bars/paused.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/jobfilterrow.dart';

class JobTab extends StatefulWidget {
  final VoidCallback postJob;
  final List<Candidate> candidates;
  final List<Map<String, dynamic>> jobPostsData;
  final User user;
  final int initialIndex;
  const JobTab({
    super.key,
    required this.candidates,
    required this.postJob,
    required this.jobPostsData,
    required this.user,
    required this.initialIndex,
  });

  @override
  State<JobTab> createState() => _JobTabState();
}

class _JobTabState extends State<JobTab> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        TabController _tabController =
            TabController(length: 3, vsync: Scaffold.of(context), initialIndex: widget.initialIndex);

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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextField(
                                decoration: searchTextFieldDecoration('Search'),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: widget.postJob,
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
                    JobFilterRowWidget(),
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
                      tabs: const [
                        Tab(text: '1 Open'),
                        Tab(text: '2 Paused'),
                        Tab(text: '1 Closed'),
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
