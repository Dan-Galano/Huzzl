import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/education_sorter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/timeperiod_picker.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResumePageEducation extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageEducation({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageEducationState createState() => _ResumePageEducationState();
}

class _ResumePageEducationState extends State<ResumePageEducation> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var pnumberController = TextEditingController();
  var emailController = TextEditingController();
  final List<EducationEntry> educationEntries = [
    EducationEntry(),
  ]; // S
  void _submitResumeOption() {
    widget.nextPage();
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
                            percent: 4 / widget.noOfResumePages,
                            backgroundColor: Colors.orange.withOpacity(0.4),
                            progressColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Education',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Provide details about your academic background, including degrees, certifications, and honors. (You can add up to 3 institutions.)",
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
                        onPressed: educationEntries.length < 3
                            ? () {
                                setState(() {
                                  educationEntries.add(EducationEntry());
                                });
                              }
                            : null, // Disable when max entries reached.
                      ),
                    ),

                    // Use a SizedBox to provide a height constraint for ListView.builder
                    SizedBox(
                      height: educationEntries.length *
                          600.0, // Adjust height as needed
                      child: ListView.builder(
                        itemCount: educationEntries.length,
                        itemBuilder: (context, index) {
                          final entry = educationEntries[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Institution ${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xff373030),
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                    Gap(20),
                                    if (educationEntries.length > 1)
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
                                              educationEntries.removeAt(index);
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
                                      'Degree/Qualification',
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
                                      .degreeController, // Use controller from the model
                                  onChanged: (value) {
                                    setState(() {
                                      entry.degree = value;
                                    });
                                  },
                                ),
                                Gap(20),

                                // Institution Name
                                Row(
                                  children: [
                                    Text(
                                      'Institution Name',
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
                                      .institutionNameController, // Use controller from the model
                                  onChanged: (value) {
                                    setState(() {
                                      entry.institutionName = value;
                                    });
                                  },
                                ),
                                Gap(20),

                                // Institution Address
                                Row(
                                  children: [
                                    Text(
                                      'Institution Address',
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
                                      .institutionAddressController, // Use controller from the model
                                  onChanged: (value) {
                                    setState(() {
                                      entry.institutionAddress = value;
                                    });
                                  },
                                ),
                                Gap(20),

                                // Time Period
                                Row(
                                  children: [
                                    Text(
                                      'Time Period',
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
                                      'Currently enrolled',
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
                                EducationTimePeriodPicker(
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
                                      EducationTimePeriodPicker(
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

                                // Honors or Awards
                                Text(
                                  'Honors and Awards',
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
                                      .honorsOrAwardsController, // Use controller from the model
                                  onChanged: (value) {
                                    setState(() {
                                      entry.honorsOrAwards = value;
                                    });
                                  },
                                ),
                                Gap(40),
                                if (educationEntries.length > 1)
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
                            EducationSorter.sortEducationEntries(
                                educationEntries);
                            for (var entry in educationEntries) {
                              print('Degree: ${entry.degree}');
                              print(
                                  'Institution Name: ${entry.institutionName}');
                              print(
                                  'Institution Address: ${entry.institutionAddress}');
                              print('Honors/Awards: ${entry.honorsOrAwards}');
                              print(
                                  'Time Period: FROM:  ${entry.fromSelectedMonth} ${entry.fromSelectedYear} TO:  ${entry.toSelectedMonth} ${entry.toSelectedYear}  ');
                              print('---');
                            }
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
                              onPressed: _submitResumeOption,
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
