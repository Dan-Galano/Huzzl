import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';

class ResumePage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;

  const ResumePage({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
  });

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final TextEditingController minimum = TextEditingController();
  final TextEditingController maximum = TextEditingController();
  String selectedRate = 'per hour'; // Default dropdown value

  void _submitMinPayForm() {
    // Validate and save pay data
    if (minimum.text.isEmpty || maximum.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please fill in all fields.')),
      // );
      return;
    }

    Map<String, dynamic> payData = {
      'rate': selectedRate,
      'minimum': minimum.text,
      'maximum': maximum.text,
    };
    widget.onSaveResumeSetup(payData);
    widget.nextPage();
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentResumeOption != null) {
      final payRate = widget.currentResumeOption!;
      selectedRate = payRate['rate'];
      minimum.text = payRate['minimum'];
      maximum.text = payRate['maximum'];
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    '2/3',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'What\'s the minimum pay you\'re looking for?',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'We use this to match you with jobs that pay around and above this amount.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rate",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBlueTextFieldDropdown(
                              isDropdown: true,
                              dropdownValue: selectedRate,
                              dropdownItems: [
                                'per hour',
                                'per day',
                                'per month',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedRate = value ?? 'per hour';
                                });
                              },
                              controller: TextEditingController(),
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Minimum",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBluePrefix(
                              controller: minimum,
                              hintText: 'Enter amount',
                              obscureText: false,
                              prefixText: '₱ ',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "To",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff8E8E8E),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Maximum",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBluePrefix(
                              controller: maximum,
                              hintText: 'Enter amount',
                              obscureText: false,
                              prefixText: '₱ ',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Skip",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          minimum.clear();
                          maximum.clear();
                          selectedRate = 'per hour';

                          Map<String, dynamic> payData = {
                            'rate': selectedRate,
                            'minimum': minimum.text,
                            'maximum': maximum.text,
                          };
                          widget.onSaveResumeSetup(payData);
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
                            onPressed: _submitMinPayForm,
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
