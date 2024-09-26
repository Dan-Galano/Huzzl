import 'dart:math';

import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';

class JobProvider with ChangeNotifier {
  List<Map<String, String>> _jobs = [];
  List<Map<String, String>> _defaultJobs =
      []; // when user clicks X icon so jobs wont load again
  bool _hasResults = true;
  bool _isLoading = false;

  List<Map<String, String>> get jobs => _jobs;
  bool get hasResults => _hasResults;
  bool get isLoading => _isLoading;

  Future<void> loadJobs([String searchQuery = '']) async {
    {
      _isLoading = true;
      _hasResults = true;
      notifyListeners();

      try {
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

        if (searchQuery.isNotEmpty) {
          _jobs.clear();
        }

        _jobs = [];

        _jobs.addAll(jobstreetJobs.where(
            (job) => job['description'] != 'Error fetching description'));

        _jobs.addAll(linkedInJobs.where(
            (job) => job['description'] != 'Error fetching description'));

        _jobs.addAll(onlineJobsJobs);
        _jobs.addAll(kalibrrJobs);

        if (searchQuery.isEmpty) {
          _jobs.addAll(philJobNetJobs);
        }

        if (searchQuery.isEmpty) {
          _defaultJobs.addAll(jobstreetJobs.where(
              (job) => job['description'] != 'Error fetching description'));

          _defaultJobs.addAll(linkedInJobs.where(
              (job) => job['description'] != 'Error fetching description'));

          _defaultJobs.addAll(onlineJobsJobs);
          _defaultJobs.addAll(kalibrrJobs);
          _defaultJobs.addAll(philJobNetJobs);
        }

        _hasResults = _jobs.isNotEmpty;
        notifyListeners();
      } catch (e) {
        print('Error loading jobs: $e');
      }

      _isLoading = false;
      jobs.shuffle(Random());
      notifyListeners();
    }
  }

  void restoreDefaultJobs() {
    // Restore the default jobs when the search field is cleared
    _jobs = List.from(_defaultJobs);
    notifyListeners();
  }
}
