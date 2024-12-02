import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/experience_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/timeperiod_picker.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ResumePageExperience2 extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageExperience2({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageExperience2State createState() => _ResumePageExperience2State();
}

class _ResumePageExperience2State extends State<ResumePageExperience2> {
  final _formKey = GlobalKey<FormState>();
  final List<ExperienceEntry> experienceEntries = [
    ExperienceEntry(),
  ];
  void _submitExperience() {
    if (_formKey.currentState!.validate()) {
      try {
        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);

        resumeProvider.updateExperienceEntries(experienceEntries);

        ExperienceSorter.sortExperienceEntries(experienceEntries);

        for (var entry in resumeProvider.experience!) {
          print('job title: ${entry.jobTitle}');
          print('company Name: ${entry.companyName}');
          print('company Address: ${entry.companyAddress}');
          print('From: ${entry.fromSelectedMonth} ${entry.fromSelectedYear}');
          print('To: ${entry.toSelectedMonth} ${entry.toSelectedYear}');
          print(
              'responsibilities/achievements: ${entry.responsibilitiesAchievements}');
          print('Is Present: ${entry.isPresent}');
          print('---');
        }

        widget.nextPage();
      } catch (e) {
        print('Error updating resume information: $e');
      }
    }
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
                child: Form(
                  key: _formKey,
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
                              percent: 5 / widget.noOfResumePages,
                              backgroundColor: Colors.orange.withOpacity(0.4),
                              progressColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Work Experience',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Highlight your professional background, including roles, responsibilities, and achievements in previous positions.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Gap(40),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            '+ Add another',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff373030),
                              fontFamily: 'Galano',
                            ),
                          ),
                          onPressed: experienceEntries.length < 11
                              ? () {
                                  setState(() {
                                    experienceEntries.add(ExperienceEntry());
                                  });
                                }
                              : null, // Disable when max entries reached.
                        ),
                      ),

                      // Use a SizedBox to provide a height constraint for ListView.builder
                      SizedBox(
                        height: experienceEntries.length *
                            600.0, // Adjust height as needed
                        child: ListView.builder(
                          itemCount: experienceEntries.length,
                          itemBuilder: (context, index) {
                            final entry = experienceEntries[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Work Experience ${index + 1}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Gap(20),
                                      if (experienceEntries.length > 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                experienceEntries
                                                    .removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                  Gap(10),

                                  // Degree Field
                                  Row(
                                    children: [
                                      Text(
                                        'Job Title',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(5),
                                  CustomTextFormField(
                                    controller: entry
                                        .jobTitleController, // Use controller from the model
                                    onChanged: (value) {
                                      setState(() {
                                        entry.jobTitle = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (entry
                                          .jobTitleController.text.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(20),

                                  // Institution Name
                                  Row(
                                    children: [
                                      Text(
                                        'Company Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(5),
                                  CustomTextFormField(
                                    controller: entry
                                        .companyNameController, // Use controller from the model
                                    onChanged: (value) {
                                      setState(() {
                                        entry.companyName = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (entry
                                          .companyNameController.text.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(20),

                                  // Institution Address
                                  Row(
                                    children: [
                                      Text(
                                        'Company Address',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(5),
                                  CustomTextFormField(
                                    controller: entry
                                        .companyAddressController, // Use controller from the model
                                    onChanged: (value) {
                                      setState(() {
                                        entry.companyAddress = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (entry.companyAddressController.text
                                          .isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(20),

                                  // Time Period
                                  Row(
                                    children: [
                                      Text(
                                        'Dates of Employment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(5),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: entry.isPresent,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            entry.isPresent = value ?? false;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Currently work here',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(5),
                                  Text(
                                    'From',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff373030),
                                      fontFamily: 'Galano',
                                    ),
                                  ),
                                  Gap(5),
                                  TimePeriodPicker(
                                    selectedMonth: entry.fromSelectedMonth,
                                    selectedYear: entry.fromSelectedYear,
                                    onMonthChanged: (month) {
                                      setState(() {
                                        entry.fromSelectedMonth = month;
                                      });
                                    },
                                    onYearChanged: (year) {
                                      setState(() {
                                        entry.fromSelectedYear = year;
                                      });
                                    },
                                    validatorMonth: (month) {
                                      if (month == null) {
                                        return 'Please select a month';
                                      }
                                      return null;
                                    },
                                    validatorYear: (year) {
                                      if (year == null) {
                                        return 'Please select a year';
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(5),
                                  Text(
                                    'To',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff373030),
                                      fontFamily: 'Galano',
                                    ),
                                  ),
                                  Gap(5),
                                  if (!entry.isPresent)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TimePeriodPicker(
                                          selectedMonth: entry.toSelectedMonth,
                                          selectedYear: entry.toSelectedYear,
                                          onMonthChanged: (month) {
                                            setState(() {
                                              entry.toSelectedMonth = month;
                                            });
                                          },
                                          onYearChanged: (year) {
                                            setState(() {
                                              entry.toSelectedYear = year;
                                            });
                                          },
                                          validatorMonth: (month) {
                                            if (month == null) {
                                              return 'Please select a month';
                                            }
                                            return null;
                                          },
                                          validatorYear: (year) {
                                            if (year == null) {
                                              return 'Please select a year';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      'Present',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff373030),
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                  Gap(20),

                                  Text(
                                    'Key Responsibilities and Achievements',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff373030),
                                      fontFamily: 'Galano',
                                    ),
                                  ),
                                  Gap(5),
                                  CustomTextFormField(
                                    maxLines: 10,
                                    controller: entry
                                        .responsibilitiesAchievementsController,
                                    onChanged: (value) {
                                      setState(() {
                                        entry.responsibilitiesAchievements =
                                            value
                                               .split('\n')
          .map((line) => line.trim()) 
          .where((line) => line.isNotEmpty) 
          .map((line) => '• $line') 
          .join('\n'); 
                                      });
                                    },
                                    validator: (value) {
                                      if (entry
                                          .responsibilitiesAchievementsController
                                          .text
                                          .isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                  ),

                                  Gap(40),
                                  if (experienceEntries.length > 1)
                                    Divider(
                                      color: Colors.orange,
                                      thickness: 2,
                                    ),
                                  Gap(40),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text("Skip",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                            

                              widget.nextPage();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 130,
                              child: BlueFilledCircleButton(
                                onPressed: _submitExperience,
                                text: 'Next',
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
