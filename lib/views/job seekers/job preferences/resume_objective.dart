import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/string_formatter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ResumePageObjective extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageObjective({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageObjectiveState createState() => _ResumePageObjectiveState();
}

class _ResumePageObjectiveState extends State<ResumePageObjective> {
  var objectiveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _submitObjective() {
    if (_formKey.currentState!.validate()) {
      try {
        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);

        String objective = objectiveController.text.capitalizeEachSentence();

        resumeProvider.updateObjective(objective);

        print("objective:  $objective");

        // Proceed to the next page
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
          Container(
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
                            percent: 2 / widget.noOfResumePages,
                            backgroundColor: Colors.orange.withOpacity(0.4),
                            progressColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Objective',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'A brief statement highlighting your career goals and key qualifications. (50-100 words)',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Gap(40),
                    CustomTextFormField(
                      hintText:
                          "E.g., 'A results-driven marketing professional seeking to leverage expertise in social media strategy and content creation to help a growing tech company reach new customers.'",
                      controller: objectiveController,
                      maxWords: 100,
                      minWords: 50,
                      maxLines: 10,
                      validator: (value) {
                        if (objectiveController.text.trim().isEmpty) {
                          return 'Objective is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 100),
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
                              onPressed: _submitObjective,
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
