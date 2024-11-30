import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as prefix;
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/education_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/experience_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:provider/provider.dart';

class AutoBuildResumeProvider extends ChangeNotifier {
  String? extractedText;
  String? fname;
  String? lname;
  String? pnumber;
  String? email;
  Map<String, dynamic>? locationData;
  String? objective;
  List<String>? selectedSkills;
  List<EducationEntry>? educationEntries;
  List<ExperienceEntry>? experienceEntries;

  Future<bool> generateResumeContent(
      BuildContext context, String extractedText) async {
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

If the above is not a resume type and then just say 'error', nothing else.
Please extract the following resume information from the provided text above. Always input each data in a bracket. Strictly follow this specific structure (including spacing) Refer to example output:
Important Notes:
If any information is missing or unclear, please leave it as `null` or empty.
Please ensure the response strictly follows this format for each section.
Avoid adding any additional text or explanations outside the required fields.
Ensure that each field is populated according to the information found in the text. If a section is not present in the text, leave it as null like 'first-name:[null]'.

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
   skills:[List of Skills] (If skills are not explicitly mentioned, extract them from the objective or other relevant sections. separate by comma e.g. [adaptability, creativity])

5. Education: (add another set of this {degree,institution-name,institution-address,honors-awards,start-year,end-year} if there's more than one. the latest based on dates will be always on the top of the list)
  degree:[Degree or level of education]
  institution-name:[Institution Name]
  institution-address:[Institution Address]
  honors-awards:[Honors, awards, coursework, or any other descriptions] (use semicolon ';' to separate every description, e.g., '[statement1; statement2; statement3]')
  start-month:[Start month] (e.g. 'January')
  start-year:[Start Year] (e.g. '2024')
  end-month:[End month] (e.g. 'December')
  end-year:[End Year] (if 'Present' available, then set 'isPresent' to true value)
  isPresent:[true/false] (see the whole info indicating Present like currently enrolled, etc.)


6. Experience:(add another set of this {job-title,company-name,company-address,job-responsibilities-achievements,start-year,end-year} if there's more than one. the latest based on dates will be always on the top of the list)
  job-title:[Job Title]
  company-name:[Company Name]
  company-address:[Company Address]
  job-responsibilities-achievements:[Responsibilities/Achievements/description](use semicolon ';' to separate every description, e.g., '[statement1; statement2; statement3]')
  start-month:[Start month] (e.g. 'January')
  start-year:[Start year] (e.g. '2024')
  end-month:[End month] (e.g. 'December')
  end-year:[End Year] (if 'Present' available, then set 'isPresent' to true value)
  isPresent:[true/false] (see the whole info indicating Present like currently working, etc.)
""";

      print("passed here 2");
      final response =
          await model.generateContent([prefix.Content.text(prompt)]);
      if (response.text!.trim().toLowerCase().contains('error')) {
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
          "⚠︎ Oops! It must be a resume.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 5),
        );
        return false;
      }
      final finalResponse = response.text!
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .map((line) => '$line')
          .join('\n');
      print(finalResponse);

      _processResumeData(context, finalResponse);
      return true;
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
      return false;
    }
  }

  void _processResumeData(BuildContext context, String responseText) {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    // Extract personal info
    String firstName = _extractPersonalInfo(responseText, 'first_name') ?? '';
    String lastName = _extractPersonalInfo(responseText, 'last_name') ?? '';
    String phoneNumber =
        _extractPersonalInfo(responseText, 'phone_number') ?? '';
    String emailAddress = _extractPersonalInfo(responseText, 'email') ?? '';

    // Update the resume provider with personal info
    resumeProvider.updateName(firstName, lastName);
    resumeProvider.updateEmail(emailAddress);
    resumeProvider.updatePhoneNumber(phoneNumber);

    // Extract and update location data
    Map<String, dynamic> locationData = _extractLocationData(responseText);
    resumeProvider.updateLocation(locationData);

    // Extract and update objective
    String objectiveText = _extractObjective(responseText) ?? '';
    resumeProvider.updateObjective(objectiveText);

    // Extract and update skills
    List<String> skills = _extractSkills(responseText);
    resumeProvider.updateSkills(skills);

    // Extract and update education entries
    List<EducationEntry> educationEntries =
        _extractEducationEntries(responseText);
    resumeProvider.updateEducationEntries(educationEntries);

    // Extract and update experience entries
    List<ExperienceEntry> experienceEntries =
        _extractExperienceEntries(responseText);
    resumeProvider.updateExperienceEntries(experienceEntries);

    // Notify listeners (this is handled inside each update function, no need for another notifyListeners call here)
  }

  String? _extractPersonalInfo(String responseText, String field) {
    switch (field) {
      case 'first_name':
        return _handleNullString(
            _extractWithRegex(responseText, r'first-name:\[([^\]]+)\]'));
      case 'last_name':
        return _handleNullString(
            _extractWithRegex(responseText, r'last-name:\[([^\]]+)\]'));
      case 'phone_number':
        return _handleNullString(
            _extractWithRegex(responseText, r'phone-number:\[([^\]]*)\]'));
      case 'email':
        return _handleNullString(
            _extractWithRegex(responseText, r'email-address:\[([^\]]+)\]'));
      default:
        return null;
    }
  }

  String? _handleNullString(String? value) {
    // Check if the value is 'null' (as a string) and return null instead
    return (value != null && value.trim() != 'null') ? value : null;
  }

  String? _extractWithRegex(String text, String pattern) {
    final regex = RegExp(pattern);
    final match = regex.firstMatch(text);
    return match != null ? match.group(1)?.trim() : null;
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

  String? _extractLocationField(String responseText, String field) {
    String? value = '';
    switch (field) {
      case 'region':
        value = _extractWithRegex(responseText, r'region:\[([^\]]*)\]');
        break;
      case 'province':
        value = _extractWithRegex(responseText, r'province:\[([^\]]*)\]');
        break;
      case 'city':
        value = _extractWithRegex(responseText, r'city:\[([^\]]*)\]');
        break;
      case 'barangay':
        value = _extractWithRegex(responseText, r'barangay:\[([^\]]*)\]');
        break;
      case 'other_location':
        value = _extractWithRegex(responseText, r'other-location:\[([^\]]*)\]');
        break;
    }

    // Check if the value is the string 'null' and return null instead
    return (value != null && value.trim() != 'null') ? value : null;
  }

  String? _extractObjective(String responseText) {
    return _handleNullString(
        _extractWithRegex(responseText, r'objective:\[([^\]]+)\]'));
  }

  List<String> _extractSkills(String responseText) {
    String skillsText = _handleNullString(
            _extractWithRegex(responseText, r'skills:\[([^\]]+)\]')) ??
        '';

    if (skillsText.isNotEmpty) {
      return skillsText.split(',').map((skill) => skill.trim()).toList();
    }
    return [];
  }

  List<EducationEntry> _extractEducationEntries(String responseText) {
    List<EducationEntry> entries = [];
    RegExp regExp = RegExp(
        r'degree:\[([^\]]+)\]\s*institution-name:\[([^\]]+)\]\s*institution-address:\[([^\]]+)\]\s*honors-awards:\[([^\]]+)\]\s*start-month:\[([^\]]+)\]\s*start-year:\[([^\]]*)\]\s*end-month:\[([^\]]+)\]\s*end-year:\[([^\]]*)\]\s*isPresent:\[([^\]]+)\]');

    Iterable<RegExpMatch> matches = regExp.allMatches(responseText);

    for (var match in matches) {
      EducationEntry entry = EducationEntry();

      // Extract degree, institution name, institution address, honors, and start/end details
      entry.degree = _handleNullString(match.group(1)) ?? '';
      entry.institutionName = _handleNullString(match.group(2)) ?? '';
      entry.institutionAddress = _handleNullString(match.group(3)) ?? '';

      // Format honors or awards with bullets
      entry.honorsOrAwards =
          _formatListWithBullets(_handleNullString(match.group(4)) ?? '');

      entry.fromSelectedMonth = _handleNullString(match.group(5));
      entry.fromSelectedYear = _handleNullString(match.group(6)) != null
          ? int.tryParse(match.group(6) ?? '') ?? null
          : null;
      entry.toSelectedMonth = _handleNullString(match.group(7));
      entry.toSelectedYear = _handleNullString(match.group(8)) != null
          ? int.tryParse(match.group(8) ?? '') ?? null
          : null;

      // Check if the end year is 'Present'
      entry.isPresent = match.group(9) == 'true' ? true : false;

      // Assign values to controllers if necessary
      entry.degreeController.text = entry.degree ?? '';
      entry.institutionNameController.text = entry.institutionName ?? '';
      entry.institutionAddressController.text = entry.institutionAddress ?? '';
      entry.honorsOrAwardsController.text = entry.honorsOrAwards ?? '';

      // Add the entry to the list
      entries.add(entry);
    }

    EducationSorter.sortEducationEntries(entries);
    return entries;
  }

  List<ExperienceEntry> _extractExperienceEntries(String responseText) {
    List<ExperienceEntry> entries = [];
    RegExp regExp = RegExp(
        r'job-title:\[([^\]]+)\]\s*company-name:\[([^\]]+)\]\s*company-address:\[([^\]]+)\]\s*job-responsibilities-achievements:\[([^\]]*)\]\s*start-month:\[([^\]]+)\]\s*start-year:\[([^\]]*)\]\s*end-month:\[([^\]]+)\]\s*end-year:\[([^\]]*)\]\s*isPresent:\[([^\]]+)\]');

    Iterable<RegExpMatch> matches = regExp.allMatches(responseText);

    for (var match in matches) {
      ExperienceEntry entry = ExperienceEntry();

      // Extract job title, company name, company address, and job responsibilities
      entry.jobTitle = _handleNullString(match.group(1)) ??
          ''; // Fallback to empty string if null
      entry.companyName = _handleNullString(match.group(2)) ?? '';
      entry.companyAddress = _handleNullString(match.group(3)) ?? '';

      // Format responsibilities with bullets
      entry.responsibilitiesAchievements =
          _formatListWithBullets(_handleNullString(match.group(4)) ?? '');

      // Extract start month and year
      entry.fromSelectedMonth = _handleNullString(match.group(5)) ?? '';
      entry.fromSelectedYear = _handleNullString(match.group(6)) != null
          ? int.tryParse(match.group(6) ?? '') ?? null
          : null;

      // Extract end month and year
      entry.toSelectedMonth = _handleNullString(match.group(7)) ?? '';
      entry.toSelectedYear = _handleNullString(match.group(8)) != null &&
              match.group(8) != 'Present'
          ? int.tryParse(match.group(8) ?? '') ?? null
          : null;

      // Check if the position is currently active (i.e., end year is 'Present')
      entry.isPresent = match.group(9) == 'true' ? true : false;

      // Assign values to controllers if necessary
      entry.jobTitleController.text = entry.jobTitle;
      entry.companyNameController.text = entry.companyName;
      entry.companyAddressController.text = entry.companyAddress;
      entry.responsibilitiesAchievementsController.text =
          entry.responsibilitiesAchievements;

      // Add the entry to the list
      entries.add(entry);
    }

    ExperienceSorter.sortExperienceEntries(entries);
    return entries;
  }

  String _formatListWithBullets(String text) {
    if (text.isEmpty) return ''; // Return empty string if text is empty

    // Split the text by semicolons and remove extra spaces
    List<String> items = text.split(';').map((item) => item.trim()).toList();

    // Remove empty items
    items.removeWhere((item) => item.isEmpty);

    // Join with bullet points
    return items.map((item) => '• $item').join('\n');
  }
}
