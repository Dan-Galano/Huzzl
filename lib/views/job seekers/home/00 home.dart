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
    // loadJobs(); // Load default jobs on startup
    // final jobProvider = Provider.of<JobProvider>(context, listen: false);
    // jobProvider.loadJobs();
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
    // jobProvider.restoreDefaultJobs(); // Restore default jobs
    setState(() {
      isSearching = false;
    });
    jobProvider.loadJobs();
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
                      Text(
                        'Date posted',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(8),
                      DropdownButtonFormField<String>(
                        // value: _selectedDate,
                        items: [
                          DropdownMenuItem(
                              value: 'Last 24 hours',
                              child: Text('Last 24 hours')),
                          DropdownMenuItem(
                              value: 'Last 7 days', child: Text('Last 7 days')),
                          DropdownMenuItem(
                              value: 'Last 30 days',
                              child: Text('Last 30 days')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            // _selectedDate = value;
                          });
                        },
                        hint: Text(
                          'Select date posted',
                          style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                        decoration: InputDecoration(
                          // labelText: 'Select date posted',
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

                      // Salary range
                      Text(
                        'Salary range',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(8),
                      DropdownButtonFormField<String>(
                        // value: _selectedRate,
                        items: [
                          DropdownMenuItem(
                              value: 'Hourly', child: Text('Hourly')),
                          DropdownMenuItem(
                              value: 'Monthly', child: Text('Monthly')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            // _selectedRate = value;
                          });
                        },
                        hint: Text(
                          'Select rate',
                          style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                        decoration: InputDecoration(
                          // labelText: 'Select date posted',
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
                      SizedBox(height: 16),

                      // Custom salary input fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                // prefixIcon: Icon(Icons.money),
                                labelText: '₱ Min',
                                labelStyle: TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 15,
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
                          SizedBox(width: 8),
                          Text('/hr', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                // prefixIcon: Icon(Icons.money),
                                labelText: '₱ Max',
                                labelStyle: TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 15,
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
                        ],
                      ),
                      SizedBox(height: 16),

                      // Job post history checkboxes
                      Text(
                        'Job post history',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (val) {},
                        title: Text(
                          'No hires',
                          style: TextStyle(fontFamily: 'Galano', fontSize: 14),
                        ),
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (val) {},
                        title: Text(
                          '1 to 9 hires',
                          style: TextStyle(fontFamily: 'Galano', fontSize: 14),
                        ),
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (val) {},
                        title: Text(
                          '10+ hires',
                          style: TextStyle(fontFamily: 'Galano', fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Schedule checkboxes
                      Text(
                        'Schedule',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (val) {},
                        title: Text(
                          'Less than 30 hrs/week',
                          style: TextStyle(fontFamily: 'Galano', fontSize: 14),
                        ),
                      ),
                      CheckboxListTile(
                        value: false,
                        onChanged: (val) {},
                        title: Text(
                          'More than 30 hrs/week',
                          style: TextStyle(fontFamily: 'Galano', fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Job type dropdown
                      DropdownButtonFormField<String>(
                        // value: _selectedJobType,
                        items: [
                          DropdownMenuItem(
                              value: 'Full-time', child: Text('Full-time')),
                          DropdownMenuItem(
                              value: 'Part-time', child: Text('Part-time')),
                          DropdownMenuItem(
                              value: 'Contract', child: Text('Contract')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            // _selectedJobType = value;
                          });
                        },
                        hint: Text(
                          'Job type',
                          style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                        decoration: InputDecoration(
                          // labelText: 'Job type',
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
                              child: Container(
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
