import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/open_in_newtab.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ApplicationView extends StatefulWidget {
  final String jobPostId;
  final String jobSeekerId;
  final String jobApplication;

  ApplicationView({
    Key? key,
    required this.jobPostId,
    required this.jobSeekerId,
    required this.jobApplication,
  }) : super(key: key);

  @override
  State<ApplicationView> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  List<dynamic> skills = [];
  List<dynamic> preScreenQuestion = [];
  List<dynamic> preScreenAnswer = [];

  //Portfolio
  String portfolioPath = "";

  @override
  void initState() {
    super.initState();
    fetchJobPost();
    fetchData();
  }

  void fetchData() async {
    try {
      await Future.wait([fetchJobPost(), fetchJobApplication()]);
    } catch (e) {
      print('Error in fetchData: $e');
    }
  }

  Future<void> fetchJobPost() async {
    print("${widget.jobApplication} hereeeeeeeeeeeee ${widget.jobSeekerId}");
    final recruiterId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final jobPostDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(widget.jobPostId)
          .get();

      if (jobPostDoc.exists) {
        var jobPostData = jobPostDoc.data();
        // String skillsString = jobPostData?['skills'] ?? '';
        // String preScreenQuestionString =
        //     jobPostData?['preScreenQuestions'] ?? '';

        setState(() {
          preScreenQuestion = jobPostData?['preScreenQuestions'] ?? [];
          // skills = skillsString.split(', ').where((e) => e.isNotEmpty).toList();
          // preScreenQuestion = preScreenQuestionString
          //     .split(RegExp(r',\s*(?=[A-Z])'))
          //     .where((e) => e.isNotEmpty)
          //     .toList();
        });
      } else {
        print('No job post found');
      }
    } catch (e) {
      print('Error fetching job post: $e');
    }
  }

  Future<void> fetchJobApplication() async {
    try {
      final jobseekerInformationDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.jobSeekerId)
          .get();

      final jobseekerData = jobseekerInformationDoc.data();

      setState(() {
        portfolioPath = jobseekerData!['portfolioFileName'];
      });

      final jobApplicationDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.jobSeekerId)
          .collection('job_application')
          .doc(widget.jobApplication) // Assuming you meant jobPostId here
          .get();

      if (jobApplicationDoc.exists) {
        final jobApplicationData = jobApplicationDoc.data();

        if (jobApplicationData != null) {
          setState(() {
            preScreenAnswer = jobApplicationData['preScreenAnswer'] ?? [];
          });
          print("List of answer ${preScreenAnswer.length}");
        } else {
          print('No data found in the job application document.');
        }
      } else {
        print('No job application document found.');
      }
    } catch (e) {
      print('Error fetching job application: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (preScreenAnswer.isEmpty && preScreenQuestion.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Applicant Qualifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF202855),
              ),
            ),
            Gap(10),
            if (preScreenQuestion.isNotEmpty && preScreenQuestion.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: preScreenQuestion.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final question = preScreenQuestion.isNotEmpty
                      ? preScreenQuestion[index]
                      : 'Loading question...';
                  final answer = preScreenAnswer.length > index
                      ? preScreenAnswer[index]
                      : 'Loading answer...';

                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFD1E1FF),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pre-screen question ${index + 1}:",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff202855),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          question,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1.2, color: Color(0xFFD1E1FF)),
                        const SizedBox(height: 10),
                        const Text(
                          "Applicant's Answer:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff202855),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          answer,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff505050),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              const Text(
                "No pre-screen questions available.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              height: 40,
            ),
            // Text(
            //   "Required Skills for the Job",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //     color: Color(0xFF202855),
            //   ),
            // ),
            // Gap(20),
            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 8.0,
            //   children: skills
            //       .map((skill) => Chip(
            //             label: Text(skill),
            //           ))
            //       .toList(),
            // ),
            // Divider(
            //   thickness: 1,
            //   color: Colors.grey,
            //   height: 40,
            // ),
            Text(
              "Portfolio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF202855),
              ),
            ),
            Gap(20),
            portfolioPath.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Replace with your function to open the PDF
                          print("Open PDF");

                          openPdfInNewTab('assets/pdf/$portfolioPath');
                        },
                        child: Text(
                          "Open Portfolio in New Tab",
                          style: TextStyle(color: Color(0xFFff9800)),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 800,
                          maxWidth: 800,
                        ),
                        child: SfPdfViewer.asset(
                          'assets/pdf/$portfolioPath',
                          canShowScrollHead: true,
                          canShowScrollStatus: true,
                          onDocumentLoaded: (details) =>
                              print('Document loaded'),
                          onDocumentLoadFailed: (details) =>
                              print('Document failed to load'),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                          'No portfolio uploaded.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
            Divider(
              thickness: 2,
              color: Color(0xFFff9800),
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
