import 'dart:math';

import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, String>> _jobs = [];
  List<Map<String, String>> _defaultJobs = []; // Store the default jobs
  bool _hasResults = true;
  bool _isLoading = false;

  List<Map<String, String>> get jobs => _jobs;
  bool get hasResults => _hasResults;
  bool get isLoading => _isLoading;

  Future<void> loadJobs([String searchQuery = '']) async {
    _isLoading = true;
    _hasResults = true;
    notifyListeners();

    try {
      // Fetch job data here...
      String jobstreetHtmlContent = await fetchJobStreetData(searchQuery);
      List<Map<String, String>> jobstreetJobs =
          parseJobStreetData(jobstreetHtmlContent);
      await fetchJobStreetJobDesc(jobstreetJobs);

      String linkedInHtmlContent;
      try {
        linkedInHtmlContent = await fetchLinkedInData(searchQuery);
      } catch (e) {
        print('Error fetching LinkedIn data: $e');
        linkedInHtmlContent = '';
      }

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
      await fetchPhilJobNetJobDesc(philJobNetJobs);

      // Clear existing jobs when searching
      if (searchQuery.isNotEmpty) {
        _jobs.clear();
      }

      _jobs.addAll(jobstreetJobs
          .where((job) => job['description'] != 'Error fetching description'));
      _jobs.addAll(linkedInJobs
          .where((job) => job['description'] != 'Error fetching description'));
      _jobs.addAll(onlineJobsJobs);
      _jobs.addAll(kalibrrJobs);

      if (searchQuery.isEmpty) {
        _jobs.addAll(philJobNetJobs);

        // Save to default jobs if loading without a search query
        if (_defaultJobs.isEmpty) {
          _defaultJobs.addAll(jobstreetJobs.where(
              (job) => job['description'] != 'Error fetching description'));
          _defaultJobs.addAll(linkedInJobs.where(
              (job) => job['description'] != 'Error fetching description'));
          _defaultJobs.addAll(onlineJobsJobs);
          _defaultJobs.addAll(kalibrrJobs);
          _defaultJobs.addAll(philJobNetJobs);
        }
      }

      _hasResults = _jobs.isNotEmpty;
      notifyListeners();
    } catch (e) {
      print('Error loading jobs: $e');
    } finally {
      _isLoading = false;
      shuffleJobsWithoutTwoConsecutive(_jobs);
      notifyListeners();
    }
  }

  void restoreDefaultJobs() {
    _jobs = List.from(_defaultJobs); // Restore the default jobs
    shuffleJobsWithoutTwoConsecutive(_jobs);

    _hasResults = _jobs.isNotEmpty; // Update hasResults based on default jobs
    notifyListeners();
  }
}

void shuffleJobsWithoutTwoConsecutive(List<Map<String, String>> jobs) {
  final random = Random();

  // Step 1: Shuffle the jobs once initially
  jobs.shuffle(random);

  // Step 2: Create an empty list to store the final result
  List<Map<String, String>> result = [];

  // Step 3: Iterate and build the result list
  while (jobs.isNotEmpty) {
    bool found = false;

    // Try to find a suitable job that is not the same as the last one added to the result
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
