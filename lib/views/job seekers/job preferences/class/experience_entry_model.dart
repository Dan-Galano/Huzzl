import 'package:flutter/material.dart';

class ExperienceEntry {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController responsibilitiesAchievementsController = TextEditingController();
  
  String jobTitle = '';
  String companyName = '';
  String companyAddress = '';
  String responsibilitiesAchievements = '';
  String? fromSelectedMonth;
  int? fromSelectedYear;
  String? toSelectedMonth;
  int? toSelectedYear;
  bool isPresent = false;

  ExperienceEntry();

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'responsibilitiesAchievements': responsibilitiesAchievements,
      'fromSelectedMonth': fromSelectedMonth,
      'fromSelectedYear': fromSelectedYear,
      'toSelectedMonth': toSelectedMonth,
      'toSelectedYear': toSelectedYear,
      'isPresent': isPresent,
    };
  }
}
