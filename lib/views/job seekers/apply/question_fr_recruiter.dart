import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/apply/application_prov.dart';
import 'package:huzzl_web/views/job%20seekers/apply/application_submitted.dart';
import 'package:huzzl_web/views/job%20seekers/apply/review_details.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:provider/provider.dart';

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
  List<String> preScreenQuestion = [];
  String preScreenString = "";

  Map<String, TextEditingController> controllers = {};

  List<String> preScreenAnswer = [];

  @override
  void initState() {
    super.initState();
    // Fetch job post details to get the pre-screen questions
    getJobPostDetails(widget.jobId, widget.recruiterId);
  }

  Future<void> getJobPostDetails(String jobPostId, String recruiterId) async {
    try {
      // Fetch the document
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(recruiterId)
              .collection('job_posts')
              .doc(jobPostId)
              .get();

      if (documentSnapshot.exists) {
        // Extract the pre-screen questions
        setState(() {
          preScreenString = documentSnapshot.data()?['preScreenQuestions'];
        });
        splitPreScreenString(preScreenString);
      } else {
        debugPrint("No such document exists.");
      }
    } catch (e) {
      debugPrint("Error in fetching the job post details: ${e.toString()}");
    }
  }

  void splitPreScreenString(String stringPreScreen) {
    setState(() {
      preScreenQuestion = stringPreScreen.split(RegExp(r',\s*(?=[A-Z])'));
    });

    // Initialize controllers for each question after preScreenQuestion is set
    for (var question in preScreenQuestion) {
      controllers[question] = TextEditingController();
    }
  }

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
                      ),
                    ),
                  );
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
                    child: Text(
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: preScreenQuestion.length,
                    itemBuilder: (context, index) {
                      final question = preScreenQuestion[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                              ),
                            ),
                            const Gap(10),
                            TextFormField(
                              controller: controllers[question],
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
                          ],
                        ),
                      );
                    },
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
                          // Now, call the save functions

                          Map<String, String> answers = {};
                          controllers.forEach((question, controller) {
                            answers[question] = controller.text;
                          });

                          // Print the answers to the console
                          answers.forEach((question, answer) {
                            debugPrint('$question: $answer');
                            setState(() {
                              preScreenAnswer.add(answer);
                            });
                          });
                          final applicationProvider =
                              Provider.of<ApplicationProvider>(context,
                                  listen: false);

                          applicationProvider.saveReviewDetails(
                            context,
                            widget.jobId,
                            widget.recruiterId,
                            widget.jobTitle,
                            preScreenAnswer,
                          );
                          // applicationProvider.saveReviewDetailsInRec(context);

                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => ApplicationSubmitted()));
                          // Collect the answers and print them
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0038FF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Apply',
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
