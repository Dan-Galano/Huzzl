import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _defaultJobs = [];
  List<Map<String, dynamic>> _searchJobs = [];
  // List<String> _selectedJobTitles = [];
  bool _hasResults = true;
  bool _isLoading = false;
  String? _recWhoPostTheJob;
  String? _jobPostId;

  List<Map<String, dynamic>> get jobs => _jobs;
  List<Map<String, dynamic>> get searchJobs => _searchJobs;
  bool get hasResults => _hasResults;
  bool get isLoading => _isLoading;

  String? get recruiterPosted => _recWhoPostTheJob;
  String? get jobpostId => _jobPostId;

  // List<String> get selectedJobTitles => _selectedJobTitles;
  List<String> _selectedJobTitles = [];
  String _selectedPlatform = 'all';
  List<String> _selectedLocations = [];

  // Getter
  List<String> get selectedJobTitles => _selectedJobTitles;
  String get selectedPlatform => _selectedPlatform;
  List<String> get selectedLocations => _selectedLocations;

  // Setter
  set selectedJobTitles(List<String> value) {
    _selectedJobTitles = value;
    notifyListeners(); // Notify listeners about the change
  }

  set selectedPlatform(String platform) {
    _selectedPlatform = platform;
    notifyListeners();
  }

  set selectedLocations(List<String> locations) {
    _selectedLocations = locations;
    notifyListeners();
  }

  bool isValidSearchQuery(String query) {
    // Check if the query is valid: at least 3 characters and contains only letters and numbers
    return query.length >= 3 && RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(query);
  }

  Future<void> loadJobs([String searchQuery = '']) async {
    _isLoading = true;
    _hasResults = true;
    notifyListeners();

    if (searchQuery.isNotEmpty) {
      _searchJobs.clear();
    } else {
      _jobs.clear();
    }

    if (searchQuery.isNotEmpty && !isValidSearchQuery(searchQuery)) {
      _hasResults = false;
      notifyListeners();
      _isLoading = false;
      return;
    }

    try {
      // Fetch job data from various sources
      List<Map<String, dynamic>> huzzlJobs = await fetchAllJobPosts();
      // String jobstreetHtmlContent = await fetchJobStreetData(searchQuery);
      // List<Map<String, String>> jobstreetJobs =
      //     parseJobStreetData(jobstreetHtmlContent);
      // await fetchJobStreetJobDesc(jobstreetJobs);
      // String linkedInHtmlContent = await fetchLinkedInData(searchQuery);
      // List<Map<String, String>> linkedInJobs =
      //     parseLinkedInData(linkedInHtmlContent);
      // await fetchLinkedInJobDesc(linkedInJobs);
      // String onlineJobsHtmlContent = await fetchOnlineJobsData(searchQuery);
      // List<Map<String, String>> onlineJobsJobs =
      //     parseOnlineJobsData(onlineJobsHtmlContent);
      String kalibrrHtmlContent = await fetchKalibrrData(searchQuery);
      List<Map<String, String>> kalibrrJobs =
          parseKalibrrData(kalibrrHtmlContent);
      await fetchKalibrrJobDesc(kalibrrJobs);
      // String philJobNetHtmlContent = await fetchPhilJobNetData();
      // List<Map<String, String>> philJobNetJobs =
      //     parsePhilJobNetData(philJobNetHtmlContent);

      // Combine all jobs from all sources
      List<Map<String, dynamic>> allJobs = [
        ...huzzlJobs,
        // ...linkedInJobs,
        // ...onlineJobsJobs,
        ...kalibrrJobs,
        // ...jobstreetJobs,
        // ...philJobNetJobs,
      ];

      // Filter jobs by platform
      if (_selectedPlatform != 'all') {
        allJobs = allJobs.where((job) {
          final source = job['website']?.toLowerCase() ?? '';
          print("DONEEEEEEEEE PASSED HERE");
          return source.contains(_selectedPlatform);
        }).toList();
      }

      // Filter jobs by locations
      if (_selectedLocations.isNotEmpty) {
        allJobs = allJobs.where((job) {
          final jobLocation = job['location']?.toLowerCase() ?? '';
          return _selectedLocations.any((selectedLocation) =>
              jobLocation.contains(selectedLocation.toLowerCase()));
        }).toList();
      }

      // Filter jobs by search query
      if (searchQuery.isNotEmpty) {
        List<String> keywords = searchQuery.split(' ');
        _searchJobs.addAll(allJobs.where((job) {
          final jobTitle = job['title']?.toLowerCase() ?? '';
          final jobDescription = job['description']?.toLowerCase() ?? '';
          return keywords.any((keyword) =>
              jobTitle.contains(keyword) || jobDescription.contains(keyword));
        }).toList());
      } else {
        _jobs.addAll(allJobs);
        if (_defaultJobs.isEmpty) {
          _defaultJobs.addAll(allJobs);
        }
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
    // shuffleJobsWithoutTwoConsecutive(_jobs);

    _hasResults = _jobs.isNotEmpty;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchAllJobPosts() async {
    try {
      // Step 1: Fetch all users where 'role' is 'recruiter'
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'recruiter')
          .get();

      // Prepare a list to hold all the fetched job posts
      List<Map<String, dynamic>> fetchedJobs = [];

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
          List? responsibilities = jobPost['responsibilities'];

          String? title = jobPost['jobTitle'] as String?;
          String? description = jobPost['jobDescription'] as String?;
          String? location = jobPost['jobPostLocation'] as String?;
          String? postedDate = jobPost['posted_at']?.toString();
          String? salary = jobPost['payRate'] as String?;
          List? skills = jobPost['skills'];
          // List<String> skillsTag = skills?.split(', ') ?? [];

          // Get the UID of the job post (document ID)
          String jobPostUid = doc.id;

          // Retrieve the userUid from the document's parent (the user's UID)
          String userUid = userDoc.id;

          if (title != null && location != null) {
            String tags =
                skills!.isNotEmpty ? skills.join(', ') : 'No tags available';

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
              'responsibilities': responsibilities,
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

void shuffleJobsWithoutTwoConsecutive(List<Map<String, dynamic>> jobs) {
  final random = Random();
  jobs.shuffle(random);
  List<Map<String, dynamic>> result = [];

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

bool mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  if (map1.length != map2.length) return false;
  for (var key in map1.keys) {
    if (map1[key] != map2[key]) return false;
  }
  return true;
}
