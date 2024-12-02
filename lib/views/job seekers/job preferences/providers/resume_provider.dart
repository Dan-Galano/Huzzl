import 'package:cloud_firestore/cloud_firestore.dart';
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

  String? get fullName =>
      (fname != null && lname != null) ? '$fname $lname' : null;
  String? get phoneNumber => pnumber;
  String? get emailAddress => email;
  Map<String, dynamic>? get location => locationData;
  String? get careerObjective => objective;
  List<String>? get skills => selectedSkills;
  List<EducationEntry>? get education => educationEntries;
  List<ExperienceEntry>? get experience => experienceEntries;

  //get resume using uid
  Future<void> getResumeByJobSeekerId(String jobSeekerId) async {
    try {
      // Fetch the resume collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobSeekerId)
          .collection('resume')
          .get();

      // Ensure the collection has at least one document
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        final resumeDoc = querySnapshot.docs.first;

        // Extract the resume data
        final resumeData = resumeDoc.data();

        // Update the provider fields using the update methods
        if (resumeData.containsKey('fname') &&
            resumeData.containsKey('lname')) {
          updateName(resumeData['fname'] ?? '', resumeData['lname'] ?? '');
        }

        if (resumeData.containsKey('email')) {
          updateEmail(resumeData['email'] ?? '');
        }

        if (resumeData.containsKey('pnumber')) {
          updatePhoneNumber(resumeData['pnumber'] ?? '');
        }

        if (resumeData.containsKey('location')) {
          updateLocation(resumeData['location'] ?? {});
        }

        if (resumeData.containsKey('objective')) {
          updateObjective(resumeData['objective'] ?? '');
        }

        if (resumeData.containsKey('skills')) {
          updateSkills(List<String>.from(resumeData['skills'] ?? []));
        }

        // Mapping education entries
        if (resumeData.containsKey('education')) {
          List<EducationEntry> educationList = [];
          for (var educationMap in resumeData['education']) {
            educationList.add(EducationEntry()
              ..degree = educationMap['degree'] ?? ''
              ..institutionName = educationMap['institutionName'] ?? ''
              ..institutionAddress = educationMap['institutionAddress'] ?? ''
              ..honorsOrAwards = educationMap['honorsOrAwards'] ?? ''
              ..fromSelectedMonth = educationMap['fromSelectedMonth']
              ..fromSelectedYear = educationMap['fromSelectedYear']
              ..toSelectedMonth = educationMap['toSelectedMonth']
              ..toSelectedYear = educationMap['toSelectedYear']
              ..isPresent = educationMap['isPresent'] ?? false);
          }
          updateEducationEntries(educationList);
        }

        // Mapping experience entries
        if (resumeData.containsKey('experience')) {
          List<ExperienceEntry> experienceList = [];
          for (var experienceMap in resumeData['experience']) {
            experienceList.add(ExperienceEntry()
              ..jobTitle = experienceMap['jobTitle'] ?? ''
              ..companyName = experienceMap['companyName'] ?? ''
              ..companyAddress = experienceMap['companyAddress'] ?? ''
              ..responsibilitiesAchievements =
                  experienceMap['responsibilitiesAchievements'] ?? ''
              ..fromSelectedMonth = experienceMap['fromSelectedMonth']
              ..fromSelectedYear = experienceMap['fromSelectedYear']
              ..toSelectedMonth = experienceMap['toSelectedMonth']
              ..toSelectedYear = experienceMap['toSelectedYear']
              ..isPresent = experienceMap['isPresent'] ?? false);
          }
          updateExperienceEntries(experienceList);
        }
      } else {
        print('No resume document found for user: $jobSeekerId');
      }
    } catch (e) {
      print('Error fetching resume: $e');
    }
  }

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

  Future<void> fetchAndSetResumeDetails(String userId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('resume')
        .limit(1) 
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      final data = docSnapshot.docs.first.data();

      if (data.containsKey('fname') && data.containsKey('lname')) {
        updateName(data['fname'], data['lname']);
      }

      if (data.containsKey('pnumber')) {
        updatePhoneNumber(data['pnumber']);
      }

      if (data.containsKey('email')) {
        updateEmail(data['email']);
      }

      if (data.containsKey('location')) {
        updateLocation(data['location'] as Map<String, dynamic>);
      }

      if (data.containsKey('objective')) {
        updateObjective(data['objective']);
      }

      if (data.containsKey('skills')) {
        updateSkills(
          (data['skills'] as List<dynamic>)
              .map((skill) => skill.toString())
              .toList(),
        );
      }

      if (data.containsKey('education')) {
        updateEducationEntries(
          (data['education'] as List<dynamic>)
              .map((entry) => EducationEntry()
                ..degree = entry['degree'] ?? ''
                ..institutionName = entry['institutionName'] ?? ''
                ..institutionAddress = entry['institutionAddress'] ?? ''
                ..honorsOrAwards = entry['honorsOrAwards'] ?? ''
                ..fromSelectedMonth = entry['fromSelectedMonth']
                ..fromSelectedYear = entry['fromSelectedYear']
                ..toSelectedMonth = entry['toSelectedMonth']
                ..toSelectedYear = entry['toSelectedYear']
                ..isPresent = entry['isPresent'] ?? false)
              .toList(),
        );
      }

      if (data.containsKey('experience')) {
        updateExperienceEntries(
          (data['experience'] as List<dynamic>)
              .map((entry) => ExperienceEntry()
                ..jobTitle = entry['jobTitle'] ?? ''
                ..companyName = entry['companyName'] ?? ''
                ..companyAddress = entry['companyAddress'] ?? ''
                ..responsibilitiesAchievements =
                    entry['responsibilitiesAchievements'] ?? ''
                ..fromSelectedMonth = entry['fromSelectedMonth']
                ..fromSelectedYear = entry['fromSelectedYear']
                ..toSelectedMonth = entry['toSelectedMonth']
                ..toSelectedYear = entry['toSelectedYear']
                ..isPresent = entry['isPresent'] ?? false)
              .toList(),
        );
      }


    }
  } catch (e) {
    print('Error fetching resume details: $e');
  }
}

}
