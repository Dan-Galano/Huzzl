import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, String>> _jobs = [];
  List<Map<String, String>> _defaultJobs = [];
  List<Map<String, String>> _searchJobs = []; // New list for search results
  bool _hasResults = true;
  bool _isLoading = false;

  List<Map<String, String>> get jobs => _jobs;
  List<Map<String, String>> get searchJobs => _searchJobs;
  bool get hasResults => _hasResults;
  bool get isLoading => _isLoading;

  bool isValidSearchQuery(String query) {
    // Check if the query is valid: at least 3 characters and contains only letters and numbers
    return query.length >= 3 && RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(query);
  }

  Future<void> loadJobs([String searchQuery = '']) async {
    _isLoading = true;
    _hasResults = true; // Assume results are available until proven otherwise
    notifyListeners();

    // Clear previous search results
    if (searchQuery.isNotEmpty) {
      _searchJobs.clear();
    } else {
      _jobs.clear(); // Clear previous jobs only if no search query
    }

    // Check for gibberish or invalid search input
    if (searchQuery.isNotEmpty && !isValidSearchQuery(searchQuery)) {
      _hasResults = false; // No valid search input
      notifyListeners();
      _isLoading = false;
      return; // Exit early as no valid search
    }

    try {
      // Fetch job data from various sources
      List<Map<String, String>> huzzlJobs = await fetchAllJobPosts();
      String jobstreetHtmlContent = await fetchJobStreetData(searchQuery);
      List<Map<String, String>> jobstreetJobs =
          parseJobStreetData(jobstreetHtmlContent);
      await fetchJobStreetJobDesc(jobstreetJobs);
      String linkedInHtmlContent = await fetchLinkedInData(searchQuery);
      List<Map<String, String>> linkedInJobs =
          parseLinkedInData(linkedInHtmlContent);
      await fetchLinkedInJobDesc(linkedInJobs);
      String onlineJobsHtmlContent = await fetchOnlineJobsData(searchQuery);
      List<Map<String, String>> onlineJobsJobs =
          parseOnlineJobsData(onlineJobsHtmlContent);
      String kalibrrHtmlContent = await fetchKalibrrData(searchQuery);
      List<Map<String, String>> kalibrrJobs =
          parseKalibrrData(kalibrrHtmlContent);
      await fetchKalibrrJobDesc(kalibrrJobs);
      String philJobNetHtmlContent = await fetchPhilJobNetData();
      List<Map<String, String>> philJobNetJobs =
          parsePhilJobNetData(philJobNetHtmlContent);

      // Combine all jobs
      List<Map<String, String>> allJobs = [
        ...jobstreetJobs,
        ...huzzlJobs, // Include Huzzl jobs
        ...linkedInJobs,
        ...onlineJobsJobs,
        ...kalibrrJobs,
        ...philJobNetJobs,
      ];

      // Add jobs based on search query
      if (searchQuery.isEmpty) {
        _jobs.addAll(allJobs);
        if (_defaultJobs.isEmpty) {
          _defaultJobs
              .addAll(allJobs); // Save default jobs for later restoration
        }
      } else {
        _searchJobs.addAll(allJobs.where((job) {
          final titleMatch =
              job['title']?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false;
          final descriptionMatch = job['description']
                  ?.toLowerCase()
                  .contains(searchQuery.toLowerCase()) ??
              false;
          return titleMatch ||
              descriptionMatch; // Match by title or description
        }).toList());
      }

      // Set hasResults based on actual job availability
      _hasResults = (_jobs.isNotEmpty || _searchJobs.isNotEmpty);
      notifyListeners();
    } catch (e) {
      print('Error loading jobs: $e');
      _hasResults = false; // Set to false if there's an error
    } finally {
      _isLoading = false;
      if (searchQuery.isEmpty) {
        shuffleJobsWithoutTwoConsecutive(
            _jobs); // Shuffle jobs if no search query
      } else {
        shuffleJobsWithoutTwoConsecutive(_searchJobs); // Shuffle search results
      }
      notifyListeners();
    }
  }

  void restoreDefaultJobs() {
    _jobs = List.from(_defaultJobs);
    shuffleJobsWithoutTwoConsecutive(_jobs);

    _hasResults = _jobs.isNotEmpty;
    notifyListeners();
  }

  Future<List<Map<String, String>>> fetchAllJobPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('job_posts').get();

    List<Map<String, dynamic>> allJobPosts = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    for (var jobPost in allJobPosts) {
      String? title = jobPost['jobTitle'] as String?;
      String? description = jobPost['jobDescription'] as String?;
      String? location = jobPost['jobPostLocation'] as String?;
      String? postedDate = jobPost['posted_at']?.toString();
      String? salary = jobPost['payRate'] as String?;
      String? skills = jobPost['skills'] as String?;

      List<String> skillsTag = skills?.split(', ') ?? [];

      if (title != null && location != null) {
        String tags =
            skillsTag.isNotEmpty ? skillsTag.join(', ') : 'No tags available';

        _jobs.add({
          'datePosted': postedDate ?? 'Unknown date',
          'title': title,
          'description': description ?? 'No Description',
          'location': location,
          'tags': tags,
          'salary': salary ?? 'Salary not provided',
          'jobLink': 'No job link',
          'proxyLink': 'no proxy link',
          'website': 'assets/images/huzzl_logo_ulo.png'
        });
      }
      notifyListeners();
    }
    print(_jobs);
    return _jobs;
  }
}

void shuffleJobsWithoutTwoConsecutive(List<Map<String, String>> jobs) {
  final random = Random();
  jobs.shuffle(random);
  List<Map<String, String>> result = [];

  while (jobs.isNotEmpty) {
    bool found = false;
    for (int i = 0; i < jobs.length; i++) {
      if (result.isEmpty || !mapEquals(result.last, jobs[i])) {
        result.add(jobs.removeAt(i));
        found = true;
        break;
      }
    }

    if (!found) {
      jobs.shuffle(random);
    }
  }

  jobs.addAll(result);
}

bool mapEquals(Map<String, String> map1, Map<String, String> map2) {
  if (map1.length != map2.length) return false;
  for (var key in map1.keys) {
    if (map1[key] != map2[key]) return false;
  }
  return true;
}
