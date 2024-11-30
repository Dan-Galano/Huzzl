import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';

class ResumeProvider with ChangeNotifier {
  String? fname;
  String? lname;
  String? pnumber;
  String? email;

  Map<String, dynamic>? locationData;

  String? objective;

  List<String>? selectedSkills;
  List<EducationEntry>? educationEntries;
  List<ExperienceEntry>? experienceEntries;



  String? get fullName => (fname != null && lname != null) ? '$fname $lname' : null;
  String? get phoneNumber => pnumber;
  String? get emailAddress => email;
  Map<String, dynamic>? get location => locationData;
  String? get careerObjective => objective;
  List<String>? get skills => selectedSkills;
  List<EducationEntry>? get education => educationEntries;
  List<ExperienceEntry>? get experience => experienceEntries;

  // Update methods for the data
  void updateName(String firstName, String lastName) {
    fname = firstName;
    lname = lastName;
    notifyListeners();
  }

  void updateEmail(String emailAddress) {
    email = emailAddress;
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    pnumber = phoneNumber;
    notifyListeners();
  }

  void updateLocation(Map<String, dynamic> location) {
    locationData = location;
    notifyListeners();
  }

  void updateObjective(String newObjective) {
    objective = newObjective;
    notifyListeners();
  }

  void updateSkills(List<String> newSkills) {
    selectedSkills = newSkills;
    notifyListeners();
  }

  void updateEducationEntries(List<EducationEntry> entries) {
    educationEntries = entries;
    notifyListeners();
  }

  void updateExperienceEntries(List<ExperienceEntry> entries) {
    experienceEntries = entries;
    notifyListeners();
  }
}
