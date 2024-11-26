import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/apply/application_submitted.dart';
import 'package:huzzl_web/views/job%20seekers/apply/review_details.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class QuestionFromRecScreen extends StatefulWidget {
  final String uid;
  final String jobId;
  final String recruiterId;
  final String jobTitle;
  const QuestionFromRecScreen({
    super.key,
    required this.uid,
    required this.jobId,
    required this.recruiterId,
    required this.jobTitle,
  });

  @override
  State<QuestionFromRecScreen> createState() => _QuestionFromRecScreenState();
}

class _QuestionFromRecScreenState extends State<QuestionFromRecScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(60),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButtonback(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => ReviewDetailsScreen(
                                uid: widget.uid,
                                jobId: widget.jobId,
                                recruiterId: widget.recruiterId,
                                jobTitle: widget.jobTitle,
                              )));
                },
                iconImage: const AssetImage('assets/images/backbutton.png'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 670,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'A question from the recruiter:',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff202855),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Will you be able to reliably commute or relocate for this job?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff202855),
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  Gap(15),
                  TextFormField(
                    // controller: _answerController,
                    maxLines: null,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Cancel',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xffFE9703),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => ApplicationSubmitted()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0038FF),
                            // padding: EdgeInsets.all(20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15)),
                        child: const Text('Next',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                  Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
