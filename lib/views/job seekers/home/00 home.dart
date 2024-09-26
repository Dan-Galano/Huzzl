import 'dart:math';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  final String? resumeText;

  const JobSeekerHomeScreen({super.key, this.resumeText});

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

  List<String> datePostedOptions = [
    'Last 24 hours',
    'Last 7 days',
    'Last 30 days',
    'Anytime'
  ];
  String? selectedDate; // Default selection

  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs();
    }
  }

  @override
  bool get wantKeepAlive => true;

  void onSearch() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final searchedWord = _searchController.text.trim().toLowerCase();
    if (searchedWord.isNotEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    setState(() {
      jobProvider.jobs.shuffle(Random());
    });
  }

  void clearSearch() {
    _searchController.clear();
    // final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.restoreDefaultJobs(); // Restore default jobs
    setState(() {
      isSearching = false;
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
                  width: 350,
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(10),
                      Container(
                        height: 40,
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            hintText: 'Enter job title or keywords',
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
                      ),
                      Gap(20),
                      Text(
                        'Date posted',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(10),
                      SizedBox(
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          hint: Text(
                            'Select a date',
                            style:
                                TextStyle(fontFamily: 'Galano', fontSize: 14),
                          ),
                          // decoration: customInputDecoration(),
                          decoration: InputDecoration(
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
                          value: selectedDate,
                          onChanged: (newValue) {
                            setState(() {
                              selectedDate = newValue;
                            });
                          },
                          items: datePostedOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
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
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(
                                        10), // Adjust padding as needed
                                    child: Icon(
                                      Icons.search,
                                      color: Color(0xFFFE9703),
                                    ), // Change color if needed
                                  ),
                                  suffixIcon:
                                      isSearching // Show clear button only if searching
                                          ? IconButton(
                                              icon: Icon(Icons.clear),
                                              // onPressed: () {
                                              //   setState(() {
                                              //     _searchController.clear();
                                              //     isSearching =
                                              //         false; // Reset searching state
                                              //     // jobs.clear();
                                              //     jobProvider.jobs.clear();
                                              //   });
                                              // },
                                              onPressed: () => clearSearch(),
                                            )
                                          : null,
                                ),
                                onChanged: (value) {
                                  if (_searchController.text.isEmpty) {
                                    setState(() {
                                      isSearching = false;
                                    });
                                  }
                                  setState(() {
                                    isSearching = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              child: ElevatedButton(
                                onPressed: onSearch,
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
                        // isLoading
                        jobProvider.isLoading
                            ? Center(child: CircularProgressIndicator())
                            // : hasResults
                            : jobProvider.hasResults
                                ? Expanded(
                                    child: ListView.builder(
                                      // itemCount: jobs.length,
                                      itemCount: jobProvider.jobs.length,
                                      itemBuilder: (context, index) {
                                        return buildJobCard(
                                          // final
                                          joblink: jobProvider.jobs[index]
                                                  ['jobLink'] ??
                                              '',
                                          datePosted: jobProvider.jobs[index]
                                                  ['datePosted'] ??
                                              'No Date Posted',
                                          title: jobProvider.jobs[index]
                                              ['title']!,
                                          location: jobProvider.jobs[index]
                                                  ['location'] ??
                                              'No Location',
                                          rate: jobProvider.jobs[index]
                                                  ['salary'] ??
                                              'Not provided',
                                          description: jobProvider.jobs[index]
                                                  ['description'] ??
                                              'No description available',
                                          website: jobProvider.jobs[index]
                                              ['website']!,
                                          tags: jobProvider.jobs[index]['tags']
                                                  ?.split(', ') ??
                                              [],
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Text('No search results match')),
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
