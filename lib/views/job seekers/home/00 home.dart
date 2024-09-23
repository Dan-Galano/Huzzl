import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  final String? resumeText;

  const JobSeekerHomeScreen({super.key, this.resumeText});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  List<Map<String, String>> jobs = [];
  List<Map<String, String>> filteredJobs = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      String onlinejobsHtml = await fetchOnlineJobsData();
      // String linkedinHtml = await fetchLinkedInData();
      List<Map<String, String>> linkedInJobs =
          await fetchJobsWithDescriptions('linkedIn');
      // String kalibrrHtml = await fetchKalibrrData();
      List<Map<String, String>> kalibrrJobs =
          await fetchJobsWithDescriptions('kalibrr');
      List<Map<String, String>> philJobNetJobs =
          await fetchJobsWithDescriptions('philJobNet');
      List<Map<String, String>> jobstreetJobs =
          await fetchJobsWithDescriptions('jobStreet');

      setState(() {
        jobs = [
          ...jobstreetJobs,
          // ...parseLinkedInData(linkedinHtml),
          ...linkedInJobs,
          ...parseOnlineJobsData(onlinejobsHtml),
          ...philJobNetJobs,
          // ...parseKalibrrData(kalibrrHtml),
          ...kalibrrJobs
        ];
        filteredJobs = jobs; // By default, show all jobs.
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterJobs(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredJobs = jobs;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredJobs = jobs.where((job) {
          final title = job['title']?.toLowerCase() ?? '';
          final description = job['description']?.toLowerCase() ?? '';
          final keywords = job['tags']?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();

          return title.contains(searchQuery) ||
              description.contains(searchQuery) ||
              keywords.contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Image.asset('assets/images/huzzl.png', width: 80),
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Home',
                        style: TextStyle(
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Company Reviews',
                        style: TextStyle(
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/message-icon.png',
                          width: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/notif-icon.png',
                        width: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/user-icon.png',
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Row(
              children: [
                // Sidebar Filters
                Container(
                  width: 350,
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: [
                      buildCategoryDropdown(),
                      SizedBox(height: 16),
                      buildJobTypeFilter(),
                      SizedBox(height: 16),
                      buildClientHistoryFilter(),
                      SizedBox(height: 16),
                      buildClientLocationDropdown(),
                      SizedBox(height: 16),
                      buildProjectLengthFilter(),
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
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Job title, keywords, or company',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  filterJobs(searchController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0038FF),
                                  padding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Find Jobs',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontFamily: 'Galano',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : filteredJobs.isEmpty && isSearching
                                  ? const Center(
                                      child: Text(
                                        'No search results found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: filteredJobs.length,
                                      itemBuilder: (context, index) {
                                        final job = filteredJobs[index];

                                        List<String> tags = [];
                                        if (job['tags'] != null) {
                                          tags = job['tags']!.split(', ');
                                        }

                                        return buildJobCard(
                                          joblink: job['jobLink'] ?? '',
                                          datePosted: job['datePosted'] ??
                                              'No Date Posted',
                                          title: job['title']!,
                                          location:
                                              job['location'] ?? 'No Location',
                                          rate: job['salary'] ?? 'Not provided',
                                          description: job['description'] ??
                                              'No description available',
                                          website: job['website']!,
                                          tags: tags,
                                        );
                                      },
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
