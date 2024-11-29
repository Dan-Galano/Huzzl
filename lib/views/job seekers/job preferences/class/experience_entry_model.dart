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
}
