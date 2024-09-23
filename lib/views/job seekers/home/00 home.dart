import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  List<Map<String, String>> jobs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      String jobStreetHtml = await fetchJobStreetData();
      // String upworkHtml = await fetchUpworkData();
      // String indeedHtml = await fetchIndeedData();
      String onlinejobsHtml = await fetchOnlineJobsData();
      String linkedinHtml = await fetchLinkedInData();

      setState(() {
        jobs = [
          ...parseJobStreetData(jobStreetHtml),
          // ...parseUpworkData(upworkHtml),
          // ...parseIndeedData(indeedHtml),
          ...parseOnlineJobsData(onlinejobsHtml),
          ...parseLinkedInData(linkedinHtml),
        ];
      });
    } catch (e) {
      print(e);
    }
  }

  // KAYA NAKA COMMENT YUNG upwork and indeed KASI AYAW MA ACCESS HUHU 403 ERROR FORBIDDEN HAYST
  // Future<void> fetchJobs() async {
  //   try {
  //     final jobStreetResponse =
  //         await http.get(Uri.parse('http://127.0.0.1:5000/scrape/jobstreet'));
  //     // final upworkResponse =
  //     //     await http.get(Uri.parse('http://127.0.0.1:5000/scrape/upwork'));
  //     // final indeedResponse =
  //     //     await http.get(Uri.parse('http://127.0.0.1:5000/scrape/indeed'));
  //     final onlinejobsResponse =
  //         await http.get(Uri.parse('http://127.0.0.1:5000/scrape/onlinejobs'));
  //     final linkedinResponse =
  //         await http.get(Uri.parse('http://127.0.0.1:5000/scrape/linkedin'));

  //     if (jobStreetResponse.statusCode == 200 &&
  //         // upworkResponse.statusCode == 200 &&
  //         // indeedResponse.statusCode == 200 &&
  //         onlinejobsResponse.statusCode == 200 &&
  //         linkedinResponse.statusCode == 200) {
  //       final jobStreetData = jsonDecode(jobStreetResponse.body) as List;
  //       // final upworkData = jsonDecode(upworkResponse.body) as List;
  //       // final indeedData = jsonDecode(indeedResponse.body) as List;
  //       final onlinejobsData = jsonDecode(onlinejobsResponse.body) as List;
  //       final linkedinData = jsonDecode(linkedinResponse.body) as List;

  //       setState(() {
  //         jobs = [
  //           ...jobStreetData.map((job) => Map<String, String>.from(job)),
  //           // ...upworkData.map((job) => Map<String, String>.from(job)),
  //           // ...indeedData.map((job) => Map<String, String>.from(job)),
  //           ...onlinejobsData.map((job) => Map<String, String>.from(job)),
  //           ...linkedinData.map((job) => Map<String, String>.from(job)),
  //         ];
  //       });
  //     } else {
  //       print('Failed to load job data');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
                      child: Text(
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
                      child: Text(
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
                        buildSearchBar(),
                        SizedBox(height: 16),
                        Expanded(
                          child: jobs.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: jobs.length,
                                  itemBuilder: (context, index) {
                                    return buildJobCard(
                                      joblink: jobs[index]['jobLink'] ?? '',
                                      datePosted:
                                          jobs[index]['datePosted'] ?? '',
                                      title: jobs[index]['title']!,
                                      location: jobs[index]['location'] ?? '',
                                      rate: jobs[index]['salary'] ?? '',
                                      description:
                                          jobs[index]['description'] ?? '',
                                      tags: [
                                        "CAD",
                                        "Autodesk authCAD",
                                        "Electrical Engineering",
                                        "Construction"
                                      ], // SAMPLE TAGS
                                      // tags: (jobs[index]['tags'] as List<String>?) ?? [],
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
