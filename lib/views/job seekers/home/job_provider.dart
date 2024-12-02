import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, String>> _jobs = [];
  List<Map<String, String>> _defaultJobs = [];
  List<Map<String, String>> _searchJobs = [];
  // List<String> _selectedJobTitles = [];
  bool _hasResults = true;
  bool _isLoading = false;
  String? _recWhoPostTheJob;
  String? _jobPostId;

  List<Map<String, String>> get jobs => _jobs;
  List<Map<String, String>> get searchJobs => _searchJobs;
  bool get hasResults => _hasResults;
  bool get isLoading => _isLoading;

  String? get recruiterPosted => _recWhoPostTheJob;
  String? get jobpostId => _jobPostId;

  // List<String> get selectedJobTitles => _selectedJobTitles;
  List<String> _selectedJobTitles = [];

  // Getter
  List<String> get selectedJobTitles => _selectedJobTitles;

  // Setter
  set selectedJobTitles(List<String> value) {
    _selectedJobTitles = value;
    notifyListeners(); // Notify listeners about the change
  }

  bool isValidSearchQuery(String query) {
    // Check if the query is valid: at least 3 characters and contains only letters and numbers
    return query.length >= 3 && RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(query);
  }

  Future<void> loadJobs([String searchQuery = '']) async {
    _isLoading = true;
    _hasResults = true;
    notifyListeners();

    // Clear previous job results to prevent duplication
    if (searchQuery.isNotEmpty) {
      _searchJobs.clear();
    } else {
      _jobs.clear(); // Clear all jobs when no search query
    }

    // Check for invalid search input
    if (searchQuery.isNotEmpty && !isValidSearchQuery(searchQuery)) {
      _hasResults = false;
      notifyListeners();
      _isLoading = false;
      return;
    }
    

    try {
      // Fetch job data from various sources
      List<Map<String, String>> huzzlJobs = await fetchAllJobPosts();
      // String jobstreetHtmlContent = await fetchJobStreetData(searchQuery);
      // List<Map<String, String>> jobstreetJobs =
      //     parseJobStreetData(jobstreetHtmlContent);
      // await fetchJobStreetJobDesc(jobstreetJobs);
      // String linkedInHtmlContent = await fetchLinkedInData(searchQuery);
      // List<Map<String, String>> linkedInJobs =
      //     parseLinkedInData(linkedInHtmlContent);
      // await fetchLinkedInJobDesc(linkedInJobs);
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

      // Combine all jobs from all sources
      List<Map<String, String>> allJobs = [
        ...huzzlJobs,
        // ...linkedInJobs,
        ...onlineJobsJobs,
        ...kalibrrJobs,
        // ...jobstreetJobs,
        ...philJobNetJobs,
      ];

      // Add jobs based on the search query
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

      _hasResults = _jobs.isNotEmpty || _searchJobs.isNotEmpty;
      notifyListeners();
    } catch (e) {
      print('Error loading jobs: $e');
      _hasResults = false;
    } finally {
      _isLoading = false;
      shuffleJobsWithoutTwoConsecutive(
          searchQuery.isEmpty ? _jobs : _searchJobs);
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
    try {
      // Step 1: Fetch all users where 'role' is 'recruiter'
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'recruiter')
          .get();

      // Prepare a list to hold all the fetched job posts
      List<Map<String, String>> fetchedJobs = [];

      // Step 2: Loop through each recruiter user
      for (var userDoc in usersSnapshot.docs) {
        // Query the 'job_posts' sub-collection for each recruiter user
        QuerySnapshot jobPostsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // Access the recruiter's document by ID
            .collection('job_posts') // Access their job posts sub-collection
            .get();

        // Step 3: Loop through the job posts of the current recruiter
        for (var doc in jobPostsSnapshot.docs) {
          // Access the job post data
          Map<String, dynamic> jobPost = doc.data() as Map<String, dynamic>;

          String? title = jobPost['jobTitle'] as String?;
          String? description = jobPost['jobDescription'] as String?;
          String? location = jobPost['jobPostLocation'] as String?;
          String? postedDate = jobPost['posted_at']?.toString();
          String? salary = jobPost['payRate'] as String?;
          String? skills = jobPost['skills'] as String?;
          List<String> skillsTag = skills?.split(', ') ?? [];

          // Get the UID of the job post (document ID)
          String jobPostUid = doc.id;

          // Retrieve the userUid from the document's parent (the user's UID)
          String userUid = userDoc.id;

          if (title != null && location != null) {
            String tags = skillsTag.isNotEmpty
                ? skillsTag.join(', ')
                : 'No tags available';

            fetchedJobs.add({
              'uid': jobPostUid, // Job post UID
              'userUid': userUid, // The user UID who posted the job
              'datePosted': postedDate ?? 'Unknown date',
              'title': title,
              'description': description ?? 'No Description',
              'location': location,
              'tags': tags,
              'salary': salary ?? 'Salary not provided',
              'proxyLink': 'no proxy link',
              'website': 'assets/images/huzzl_logo_ulo.png',
            });
          }
        }
      }

      return fetchedJobs; // Return the fetched jobs
    } catch (e) {
      print('Error fetching job posts: $e');
      return [];
    }
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
