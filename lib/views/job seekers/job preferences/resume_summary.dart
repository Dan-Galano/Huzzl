import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResumePageSummary extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageSummary({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageSummaryState createState() => _ResumePageSummaryState();
}

class _ResumePageSummaryState extends State<ResumePageSummary> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var pnumberController = TextEditingController();
  var emailController = TextEditingController();
  void _submitResumeOption() {
    widget.nextPage();
  }

  String fname = "Allen";
  String lname = "Alvaro";
  String pnumber = "+639123456789";
  String email = "alllenjjames@gmail.com";

  Map<String, dynamic> locationData = {
    'region': 'Ilocos Region',
    'province': 'Pangasinan',
    'city': 'Urdaneta City',
    'barangay': 'San Vicente',
    'otherLocation': '123, Zone 4',
  };
  String objective =
      "Highly motivated and results-driven professional with strong problem-solving skills and a passion for continuous learning. Offering a solid background in [your field], I seek to leverage my expertise in [specific skills or industry] to contribute to the success of a dynamic organization. Adept at collaborating with cross-functional teams, adapting to new challenges, and delivering high-quality solutions on time. Eager to apply my skills and enthusiasm to help drive growth and achieve company goals.";
  List<String> selectedSkills = [
    'Communication Skills',
    'Decision-making',
    'Critical Thinking',
  ];
  List<EducationEntry> educationEntries = [
    EducationEntry(),
    EducationEntry(),
    EducationEntry(),
  ];

  List<ExperienceEntry> experienceEntries = [
    ExperienceEntry(),
    ExperienceEntry(),
  ];
  @override
  void initState() {
    super.initState();
    educationEntries[0].degree = "Master of Science in Computer Science";
    educationEntries[0].institutionName = "University of the Philippines";
    educationEntries[0].institutionAddress = "Quezon City, Metro Manila";
    educationEntries[0].fromSelectedMonth = 'June';
    educationEntries[0].fromSelectedYear = 2023;
    educationEntries[0].isPresent = true;
    educationEntries[1].honorsOrAwards = "Thesis Awardee";

    educationEntries[1].degree =
        "Bachelor of Science in Information Technology";
    educationEntries[1].institutionName = "Pangasinan State University";
    educationEntries[1].institutionAddress = "Urdaneta City, Pangasinan";
    educationEntries[1].fromSelectedMonth = 'January';
    educationEntries[1].fromSelectedYear = 2020;
    educationEntries[1].toSelectedMonth = 'March';
    educationEntries[1].toSelectedYear = 2023;
    educationEntries[1].honorsOrAwards = "GPA: 1.50";

    educationEntries[2].degree = "Bachelor of Arts in Political Science";
    educationEntries[2].institutionName = "University of Santo Tomas";
    educationEntries[2].institutionAddress = "Manila, Metro Manila";
    educationEntries[2].fromSelectedMonth = 'June';
    educationEntries[2].fromSelectedYear = 2017;
    educationEntries[2].toSelectedMonth = 'May';
    educationEntries[2].toSelectedYear = 2019;
    educationEntries[2].honorsOrAwards = "Dean's List (2017-2019)";

// Artificial data for experienceEntries[0]
    experienceEntries[0].jobTitle = "Software Developer";
    experienceEntries[0].companyName = "Tech Solutions Inc.";
    experienceEntries[0].companyAddress = "Makati City, Metro Manila";
    experienceEntries[0].fromSelectedMonth = 'January';
    experienceEntries[0].fromSelectedYear = 2021;
    experienceEntries[0].toSelectedMonth = 'March';
    experienceEntries[0].toSelectedYear =
        2024; // Current year or null if ongoing
    experienceEntries[0].responsibilitiesAchievements =
        "Developed multiple web applications, maintained legacy systems, and implemented performance improvements.";

// Artificial data for experienceEntries[1]
    experienceEntries[1].jobTitle = "Product Manager";
    experienceEntries[1].companyName = "Innovatech Solutions";
    experienceEntries[1].companyAddress = "Taguig City, Metro Manila";
    experienceEntries[1].fromSelectedMonth = 'May';
    experienceEntries[1].fromSelectedYear = 2020;
    experienceEntries[1].toSelectedMonth = 'December';
    experienceEntries[1].toSelectedYear = 2022;
    experienceEntries[1].responsibilitiesAchievements =
        "Led product development teams, managed the product lifecycle, and collaborated with cross-functional teams to launch new features.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 300,
                            animateFromLastPercent: true,
                            barRadius: Radius.circular(20),
                            lineHeight: 10,
                            percent:
                                widget.noOfResumePages / widget.noOfResumePages,
                            backgroundColor: Colors.orange.withOpacity(0.4),
                            progressColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Review your Huzzl resume',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Review and finalize the details of your Huzzl resume before submission.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Gap(40),
                    Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.grey[700],
                                      foregroundColor: Colors.white,
                                      child: Text("${fname[0]}${lname[0]}",
                                          style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Gap(50),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${fname}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                              ),
                                            ),
                                            Gap(5),
                                            Text(
                                              '${lname}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(5),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${pnumber}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff373030),
                                              fontFamily: 'Galano',
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${email}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff373030),
                                              fontFamily: 'Galano',
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${locationData['otherLocation']} ${locationData['barangay']}, ${locationData['city']}, ${locationData['province']}, ${locationData['region']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff373030),
                                              fontFamily: 'Galano',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ),
                          Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(20),
                                  Text(
                                    'Objective',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff373030),
                                      fontFamily: 'Galano',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Gap(5),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      objective,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff373030),
                                        fontFamily: 'Galano',
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(20),
                                        Text(
                                          'Skills',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff373030),
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Gap(5),
                                        Wrap(
                                          spacing:
                                              8.0, // Horizontal space between the cards
                                          runSpacing:
                                              8.0, // Vertical space between the cards
                                          children: List.generate(
                                            selectedSkills.length,
                                            (index) => Card(
                                              elevation: 0,
                                              color: Colors.grey[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  selectedSkills[index],
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(20),
                                        Text(
                                          'Education',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff373030),
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Gap(5),
                                        Column(
                                          children: List.generate(
                                            educationEntries.length,
                                            (index) {
                                              final entry =
                                                  educationEntries[index];
                                              String timePeriod = entry
                                                      .isPresent
                                                  ? '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present'
                                                  : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}';

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20.0),
                                                      elevation: 0,
                                                      color: Colors.grey[100]!
                                                          .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  entry.degree,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  timePeriod,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .school_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .institutionName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .institutionAddress,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            SizedBox(
                                                                height: 8.0),
                                                            if (entry
                                                                .honorsOrAwards
                                                                .trim()
                                                                .isNotEmpty) ...[
                                                              Text(
                                                                "Honors and Awards",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              Text(
                                                                entry
                                                                    .honorsOrAwards,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                            ]
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(20),
                                        Text(
                                          'Work Experience',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff373030),
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Gap(5),
                                        Column(
                                          children: List.generate(
                                            experienceEntries.length,
                                            (index) {
                                              final entry =
                                                  experienceEntries[index];
                                              String timePeriod = entry
                                                      .isPresent
                                                  ? '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present'
                                                  : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}';

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20.0),
                                                      elevation: 0,
                                                      color: Colors.grey[100]!
                                                          .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  entry
                                                                      .jobTitle,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  timePeriod,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .business_center_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .companyName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .companyAddress,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            SizedBox(
                                                                height: 8.0),
                                                            if (entry
                                                                .responsibilitiesAchievements
                                                                .trim()
                                                                .isNotEmpty) ...[
                                                              Text(
                                                                "Key Responsibilities and Achievements",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              Text(
                                                                entry
                                                                    .responsibilitiesAchievements,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 230,
                            child: BlueFilledCircleButton(
                              onPressed: _submitResumeOption,
                              text: 'Save and Continue',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}
