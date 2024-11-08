import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/darkblue_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/buttons/orange/orange_icon_outlined.dart';

class JobPostApp extends StatelessWidget {
  final String jobDate;
  final String jobTitle;
  final String jobDescription;
  final String location;
  final String time = "Less than 30 hrs/week";
  final String rate;
  final String min = '1K';
  final String max = '3K';
  final List<String> skills;
  final String clientDetails = '2 jobs posted';
  final String companysize = '2-9 people';

  const JobPostApp({
    required this.jobDate,
    required this.jobTitle,
    required this.jobDescription,
    required this.location,
    required this.rate,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 130, top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobDate,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          jobTitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 2,
                          color: Color(0xffCFCFCF),
                          width: double.infinity,
                        ),
                        SizedBox(height: 20),
                        Text(
                          jobDescription,
                          style: TextStyle(
                            color: Color(0xff6D6D6D),
                            fontSize: 16,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 2,
                          color: Color(0xffCFCFCF),
                          width: double.infinity,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: ImageIcon(
                                        AssetImage(
                                            'assets/images/location.png'),
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Philippines',
                                          style: TextStyle(
                                            color: Color(0xff202855),
                                            fontSize: 16,
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          location,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 14, 11, 11),
                                            fontSize: 16,
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(width: 100),
                            // Time Row
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 100)),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: ImageIcon(
                                        AssetImage('assets/images/time.png'),
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time',
                                          style: TextStyle(
                                            color: Color(0xff202855),
                                            fontSize: 16,
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 14, 11, 11),
                                            fontSize: 16,
                                            fontFamily: 'Galano',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 100),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 100)),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: ImageIcon(
                                    AssetImage('assets/images/peso.png'),
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rate',
                                      style: TextStyle(
                                        color: Color(0xff202855),
                                        fontSize: 16,
                                        fontFamily: 'Galano',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      rate,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 14, 11, 11),
                                        fontSize: 16,
                                        fontFamily: 'Galano',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 2,
                          color: Color(0xffCFCFCF),
                          width: double.infinity,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Skills and Expertise",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 8,
                          children: skills
                              .map((tag) => Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Chip(
                                      label: Text(
                                        tag,
                                        style: TextStyle(
                                          fontFamily: 'Galano',
                                          fontSize: 16,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 2,
                        height: 1100,
                        color: Color(0xffCFCFCF),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DarkblueBoxbutton(
                              onPressed: () {},
                              text: "Apply Now",
                              width: 300,
                            ),
                            SizedBox(height: 10),
                            OrangeIconButton(
                              onPressed: () {},
                              imagePath: 'assets/images/heart.png',
                              text: "Save Job",
                              width: 300,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'About Client',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              clientDetails,
                              style: TextStyle(
                                color: Color(0xff6D6D6D),
                                fontSize: 16,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Ph",
                              style: TextStyle(
                                color: Color(0xff6D6D6D),
                                fontSize: 16,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              companysize,
                              style: TextStyle(
                                color: Color(0xff6D6D6D),
                                fontSize: 16,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 50), // Adjust the padding as needed
              child: IconButtonback(
                onPressed: () {
                  print('Back button pressed');
                  Navigator.pop(context);
                },
                iconImage: AssetImage('assets/images/backbutton.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
