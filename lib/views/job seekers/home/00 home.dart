import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  final String? resumeText;
  final String uid;

  const JobSeekerHomeScreen({super.key, this.resumeText, required this.uid});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen>
    with AutomaticKeepAliveClientMixin {
  // List<Map<String, String>> jobs = [];
  // bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  // bool hasResults = true;
  bool isSearching = false;

  var locationController = TextEditingController();
  // List<String> selectedJobTitles = []; // Tracks selected job titles

  List<String> datePostedOptions = [
    'Last 24 hours',
    'Last 7 days',
    'Last 30 days',
    'Anytime'
  ];
  String? selectedDate; // Default selection

  List<String> loadingPhrases = [
    "Chasing Opportunities...",
    "Racing Towards Your Next Job...",
    "Finding the Perfect Fit...",
    "Running to Match Your Skills...",
    "On the Hunt for Jobs...",
    "Your Dream Job is Around the Corner...",
    "Matching You with Top Jobs...",
    "Scouting the Best Opportunities...",
    "Tracking Down the Best Matches...",
    "On a Job-Search Marathon..."
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
      jobProvider.loadJobs();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % loadingPhrases.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void onSearch() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final searchedWord = _searchController.text.trim().toLowerCase();
    if (searchedWord.isNotEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    // setState(() {
    //   jobProvider.jobs.shuffle(Random());
    // });
    print("---UID:----- ${widget.uid}");
  }

  void onFilterClicked() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    // final searchedWord = _searchController.text.trim().toLowerCase();
    String searchedWord = "";
    if (jobProvider.selectedJobTitles.length == 1) {
      searchedWord = jobProvider.selectedJobTitles[0].trim().toLowerCase();
    }
    if (searchedWord.isNotEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    // setState(() {
    //   jobProvider.jobs.shuffle(Random());
    // });
    print("---UID:----- ${widget.uid}");
  }

  void clearSearch() {
    _searchController.clear();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.restoreDefaultJobs(); // Restore default jobs

    setState(() {
      isSearching = false; // Reset searching state
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final jobProvider = Provider.of<JobProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Sidebar Filters
                Container(
                  width: 320,
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: [
                      // Location field
                      Text(
                        'Location',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'City, State',
                          hintStyle: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 14,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                        ),
                      ),
                      Gap(16),
                      DropdownWithCheckboxes(
                      sections: [
                        DropdownSection(
                          title: 'Accounting & Consulting',
                          items: [
                            'Personal & Professional Coaching',
                            'Accounting & Bookkeeping',
                            'Financial Planning',
                            'Recruiting & Human Resources',
                            'Management Consulting & Analysis',
                            'Other - Accounting & Consulting',
                          ],
                        ),
                        DropdownSection(
                          title: 'Admin Support',
                          items: [
                            'Data Entry & Transcription Services',
                            'Virtual Assistant',
                            'Project Management',
                            'Market Research & Product Reviews',
                            'Programmer'
                          ],
                        ),
                        DropdownSection(
                          title: 'Customer Service',
                          items: [
                            'Community Management & Tagging',
                            'Customer Service & Tech Support',
                          ],
                        ),
                        // Add other categories as needed
                      ],
                      maxSelections: 3, // Limit selections to 3
                      preSelectedItems: jobProvider.selectedJobTitles, // Preselected items
                      onSelectionChanged: (selectedItems) {
                        print("--SELECTED ITEM-- ${selectedItems}");
                          Provider.of<JobProvider>(context, listen: false).selectedJobTitles = selectedItems;
                     
                      },
                    ),
                    Gap(10),
                    ElevatedButton(
                              onPressed: () {
                                print("--filter jobs btn clicked--");
                                onFilterClicked();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0038FF),
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Filter jobs',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey[300],
                ),
                // Job Listings
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Search bar
                        Row(
                          children: [
                            Container(
                              width: 700,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Enter job title or keywords',
                                  hintStyle: TextStyle(fontFamily: 'Galano'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  suffixIcon: isSearching
                                      ? IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed:
                                              clearSearch, // Clear search logic
                                        )
                                      : null,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(
                                        10), // Adjust padding as needed
                                    child: Icon(
                                      Icons.search,
                                      color: Color(0xFFFE9703),
                                    ), // Change color if needed
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isSearching =
                                        _searchController.text.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: onSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0038FF),
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Find Jobs',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Main content based on search and job data state
                        jobProvider.isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/gif/huzzl_loading.gif',
                                        height: 80,
                                      ),
                                      Text(
                                        loadingPhrases[currentIndex],
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFFfd7206),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : jobProvider.hasResults &&
                                    (jobProvider.searchJobs.isNotEmpty ||
                                        jobProvider.jobs
                                            .isNotEmpty) // Show jobs if available
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: jobProvider
                                              .searchJobs.isNotEmpty
                                          ? jobProvider.searchJobs
                                              .length // Use searchJobs if a search query is active
                                          : jobProvider.jobs
                                              .length, // Use jobs if no search query is active
                                      itemBuilder: (context, index) {
                                        final job = jobProvider
                                                .searchJobs.isNotEmpty
                                            ? jobProvider.searchJobs[
                                                index] // Use filtered jobs
                                            : jobProvider
                                                .jobs[index]; // Use all jobs

                                        return buildJobCard(
                                            // uid: job['uid'] ?? '', // jobpostUid
                                            jobPostUid: job['uid'] ?? '',
                                            userId: FirebaseAuth.instance
                                                    .currentUser?.uid ??
                                                "",
                                            recruiterUid: job['userUid'] ?? '',
                                            joblink: job['jobLink'] ?? '',
                                            datePosted: job['datePosted'] ??
                                                'No Date Posted',
                                            title: job['title']!,
                                            location: job['location'] ??
                                                'No Location',
                                            rate:
                                                job['salary'] ?? 'Not provided',
                                            description: job['description'] ??
                                                'No description available',
                                            website: job['website']!,
                                            tags:
                                                job['tags']?.split(', ') ?? [],
                                            context: context);
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 180),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/huzzl_notfound.png',
                                            height: 150,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
