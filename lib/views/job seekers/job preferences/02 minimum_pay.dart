import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03%20job_titles.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';

class MinimumPayPage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  MinimumPayPage(
      {super.key, required this.nextPage, required this.previousPage});

  @override
  _MinimumPayPageState createState() => _MinimumPayPageState();
}

class _MinimumPayPageState extends State<MinimumPayPage> {
  var minimum = TextEditingController();
  var maximum = TextEditingController();

  void _submitMimPayForm() {
    // if (_formKey.currentState!.validate()) {
    //   widget.nextPage();
    // }
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: AppBar(
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     title: Image.asset(
      //       'assets/images/huzzl.png',
      //       width: 80,
      //     ),
      //     actions: [
      //       Padding(
      //         padding: const EdgeInsets.only(right: 16.0),
      //         child: IconButton(
      //           icon: Image.asset(
      //             'assets/images/account.png',
      //             width: 25,
      //             height: 25,
      //           ),
      //           onPressed: () {
      //             // action
      //           },
      //         ),
      //       ),
      //     ],
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         border: Border(
      //           bottom: BorderSide(
      //             color: Color(0xffD9D9D9),
      //             width: 3.0,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
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
                              dropdownValue: 'per hour',
                              dropdownItems: [
                                'per hour',
                                'per day',
                                'per month'
                              ],
                              onChanged: (value) {
                                setState(() {
                                  // Update state if necessary
                                });
                              },
                              controller: TextEditingController(),
                              obscureText: false,
                            )
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
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "  To",
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
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => JobseekerMainScreen(),
                            ));
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                fontFamily: 'Galano',
                                fontSize: 17,
                                color: Color(0xffFE9703)),
                          )),
                      Gap(10),
                      SizedBox(
                        width: 130,
                        child: BlueFilledCircleButton(
                          onPressed: () => _submitMimPayForm(),
                          text: 'Next',
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
              onPressed: () {
                //For debugging and UI only
                //Use PageController
                // Navigator.of(context).pop();
                widget.previousPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
