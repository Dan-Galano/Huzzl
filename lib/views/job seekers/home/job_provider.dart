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
      _jobs.addAll(onlineJobsJobs);
      _jobs.addAll(kalibrrJobs);

      if (searchQuery.isEmpty) {
        _jobs.addAll(philJobNetJobs);

        // Save to default jobs if loading without a search query
        if (_defaultJobs.isEmpty) {
          _defaultJobs.addAll(jobstreetJobs.where(
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
      _jobs.shuffle(Random());
      notifyListeners();
    }
  }

  void restoreDefaultJobs() {
    _jobs = List.from(_defaultJobs); // Restore the default jobs
    _hasResults = _jobs.isNotEmpty; // Update hasResults based on default jobs
    notifyListeners();
  }
}
