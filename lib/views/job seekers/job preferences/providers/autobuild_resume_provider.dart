import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as prefix;

class AutoBuildResumeProvider extends ChangeNotifier {
  String extractedText = '';
  String fname = '';
  String lname = '';
  String pnumber = '';
  String email = '';
  Map<String, dynamic> locationData = {};
  String objective = '';
  List<String> selectedSkills = [];
  List<EducationEntry> educationEntries = [];
  List<ExperienceEntry> experienceEntries = [];

  Future<void> generateResumeContent(String extractedText) async {
    try {
      this.extractedText = extractedText;

      await dotenv.load();
      String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
      String geminiModel = dotenv.env['MODEL']!;

      final model = prefix.GenerativeModel(
        model: geminiModel,
        apiKey: geminiAPIKey,
      );
      print("passed here 1");

      String prompt = """
${extractedText}

\n
Please extract the following resume information from the provided text above. Always input each data in a bracket. Strictly follow this specific structure (including spacing) Refer to example output:


1. Personal Information:
  first-name:[First Name] (e.g. output this as 'first-name: [Allen]')
  last-name:[Last Name]
  phone-number:[Phone Number] (if available)
  email-address:[Email Address] (if available)

2. Location Details:
  region:[Region Name]
  province:[Province Name]
  city:[City Name]
  barangay:[Barangay Name]
  other-location:[Other Location] (e.g., building number, street)

3. Objective:
  objective:[Objective/Summary/Introduction Text] (if not explicitly mentioned, you can get it based on the overall info available)

4. Skills:
   skills:[List of Skills] (If skills are not explicitly mentioned, extract them from the objective or other relevant sections.)

5. Education:
  degree: [Degree]
  institution-name: [Institution Name]
  institution address: [Institution Address]
  Honors, awards, coursework, or any other descriptions: [Honors or Descriptions]
  Start year: [Start Year]
  End year: [End Year] (if available)

  If any of the education details are missing or unclear, leave them as null or empty.

6. Experience:
  Job title: [Job Title]
  Company name: [Company Name]
  Company address: [Company Address]
  Job responsibilities or achievements: [Responsibilities/Achievements]
  Start year: [Start Year]
  End year: [End Year] (if available)

   If any of the experience details are missing or unclear, leave them as null or empty.

Important Notes:
If any information is missing or unclear, please leave it as `null` or empty.
Please ensure the response strictly follows this format for each section.
Avoid adding any additional text or explanations outside the required fields.

Ensure that each field is populated according to the information found in the text. If a section is not present in the text, leave it as null like 'first-name:[null]'.
""";

      print("passed here 2");
      final response =
          await model.generateContent([prefix.Content.text(prompt)]);
      print(response.text!);

      _processResumeData(response.text!);
    } catch (error) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = const Color(0xFfd74a4a)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;

      EasyLoading.showToast(
        "⚠︎ Oops! Something went wrong. Please check your internet connection or try again later.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 5),
      );
    }
  }

  void _processResumeData(String responseText) {
    fname = _extractPersonalInfo(responseText, 'first_name');
    print("First Name: $fname");

    lname = _extractPersonalInfo(responseText, 'last_name');
    print("Last Name: $lname");

    pnumber = _extractPersonalInfo(responseText, 'phone_number') ?? '';
    print("Phone Number: $pnumber");

    email = _extractPersonalInfo(responseText, 'email') ?? '';
    print("Email: $email");

    locationData = _extractLocationData(responseText);
    print("Location Data: $locationData");

    objective = _extractObjective(responseText);
    print("Objective: $objective");

    selectedSkills = _extractSkills(responseText);
    print("Skills: $selectedSkills");

    educationEntries = _extractEducationEntries(responseText);
    print("Education Entries: ");
    educationEntries.forEach((entry) {
      print(
          "Degree: ${entry.degree}, Institution: ${entry.institutionName}, From: ${entry.fromSelectedYear}, To: ${entry.toSelectedYear}");
    });

    experienceEntries = _extractExperienceEntries(responseText);
    print("Experience Entries: ");
    experienceEntries.forEach((entry) {
      print(
          "Job Title: ${entry.jobTitle}, Company: ${entry.companyName}, Responsibilities: ${entry.responsibilitiesAchievements}");
    });

    notifyListeners();
  }

  String _extractPersonalInfo(String responseText, String field) {
    switch (field) {
      case 'first_name':
        return _extractWithRegex(responseText, r'First Name: (\w+)');
      case 'last_name':
        return _extractWithRegex(responseText, r'Last Name: (\w+)');
      case 'phone_number':
        return _extractWithRegex(
            responseText, r'Phone: (\+?\d[\d\- ]{7,12}\d)');
      case 'email':
        return _extractWithRegex(responseText, r'Email: (\S+@\S+\.\S+)');
      default:
        return '';
    }
  }

  String _extractWithRegex(String text, String pattern) {
    final regex = RegExp(pattern);
    final match = regex.firstMatch(text);
    return match != null ? match.group(1) ?? '' : '';
  }

  Map<String, dynamic> _extractLocationData(String responseText) {
    Map<String, dynamic> location = {};
    location['regionName'] = _extractLocationField(responseText, 'region');
    location['provinceName'] = _extractLocationField(responseText, 'province');
    location['cityName'] = _extractLocationField(responseText, 'city');
    location['barangayName'] = _extractLocationField(responseText, 'barangay');
    location['otherLocation'] =
        _extractLocationField(responseText, 'other_location');
    return location;
  }

  String _extractLocationField(String responseText, String field) {
    switch (field) {
      case 'region':
        return _extractWithRegex(responseText, r'Region: ([\w\s]+)');
      case 'province':
        return _extractWithRegex(responseText, r'Province: ([\w\s]+)');
      case 'city':
        return _extractWithRegex(responseText, r'City: ([\w\s]+)');
      case 'barangay':
        return _extractWithRegex(responseText, r'Barangay: ([\w\s]+)');
      case 'other_location':
        return _extractWithRegex(responseText, r'Other Location: ([\w\s]+)');
      default:
        return '';
    }
  }

  String _extractObjective(String responseText) {
    return _extractWithRegex(responseText, r'Objective: ([\s\S]+?)\n');
  }

  List<String> _extractSkills(String responseText) {
    String skillsText =
        _extractWithRegex(responseText, r'Skills: ([\s\S]+?)\n');
    if (skillsText.isNotEmpty) {
      return skillsText.split(',').map((skill) => skill.trim()).toList();
    }
    return [];
  }

  List<EducationEntry> _extractEducationEntries(String responseText) {
    List<EducationEntry> entries = [];
    RegExp regExp = RegExp(
        r'Degree: ([\w\s]+)\s*Institution: ([\w\s]+)\s*Address: ([\w\s,]+)\s*Honors: ([\w\s]+)\s*From: (\d{4})\s*To: (\d{4})');
    Iterable<RegExpMatch> matches = regExp.allMatches(responseText);

    for (var match in matches) {
      EducationEntry entry = EducationEntry();

      entry.degree = match.group(1) ?? '';
      entry.institutionName = match.group(2) ?? '';
      entry.institutionAddress = match.group(3) ?? '';
      entry.honorsOrAwards = match.group(4) ?? '';
      entry.fromSelectedYear = int.tryParse(match.group(5) ?? '');
      entry.toSelectedYear = int.tryParse(match.group(6) ?? '');

      entry.degreeController.text = entry.degree;
      entry.institutionNameController.text = entry.institutionName;
      entry.institutionAddressController.text = entry.institutionAddress;
      entry.honorsOrAwardsController.text = entry.honorsOrAwards;

      entries.add(entry);
    }

    return entries;
  }

  List<ExperienceEntry> _extractExperienceEntries(String responseText) {
    List<ExperienceEntry> entries = [];
    RegExp regExp = RegExp(
        r'Job Title: ([\w\s]+)\s*Company: ([\w\s]+)\s*Address: ([\w\s,]+)\s*Responsibilities: ([\s\S]+?)\s*(From: (\d{4})\s*To: (\d{4}))');
    Iterable<RegExpMatch> matches = regExp.allMatches(responseText);

    for (var match in matches) {
      ExperienceEntry entry = ExperienceEntry();

      entry.jobTitle = match.group(1) ?? '';
      entry.companyName = match.group(2) ?? '';
      entry.companyAddress = match.group(3) ?? '';
      entry.responsibilitiesAchievements = match.group(4) ?? '';
      entry.fromSelectedYear = int.tryParse(match.group(6) ?? '');
      entry.toSelectedYear = int.tryParse(match.group(7) ?? '');

      entry.jobTitleController.text = entry.jobTitle;
      entry.companyNameController.text = entry.companyName;
      entry.companyAddressController.text = entry.companyAddress;
      entry.responsibilitiesAchievementsController.text =
          entry.responsibilitiesAchievements;

      entries.add(entry);
    }

    return entries;
  }
}
