import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResumePageManual1 extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  const ResumePageManual1({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
  });

  @override
  _ResumePageManual1State createState() => _ResumePageManual1State();
}

class _ResumePageManual1State extends State<ResumePageManual1> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var pnumberController = TextEditingController();
  var emailController = TextEditingController();
  void _submitResumeOption() {
    widget.nextPage();
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
                          percent: 1 / 5,
                          backgroundColor: Colors.orange.withOpacity(0.4),
                          progressColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Your primary details for professional communication.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Gap(40),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'First Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                            Gap(5),
                            CustomTextFormField(
                              controller: fnameController,
                            ),
                          ],
                        ),
                      ),
                      Gap(20),
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Last Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                            Gap(5),
                            CustomTextFormField(
                              controller: lnameController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  Gap(5),
                  CustomTextFormField(
                    controller: pnumberController,
                    keyboardType: TextInputType.phone,
                  ),
                  Gap(20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  Gap(5),
                  CustomTextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
          Positioned(
            top: 60,
            left: 350,
            child:  IconButton(
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
