import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  List<String> skills = [];
  List<String> preScreenQuestion = [];
  List<dynamic> preScreenAnswer = [];

  @override
  void initState() {
    super.initState();
    fetchJobPost();
    fetchJobApplication();
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
        String skillsString = jobPostData?['skills'] ?? '';
        String preScreenQuestionString =
            jobPostData?['preScreenQuestions'] ?? '';

        setState(() {
          skills = skillsString.split(', ').where((e) => e.isNotEmpty).toList();
          preScreenQuestion = preScreenQuestionString
              .split(RegExp(r',\s*(?=[A-Z])'))
              .where((e) => e.isNotEmpty)
              .toList();
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: preScreenQuestion.length,
                separatorBuilder: (context, index) => Gap(10),
                itemBuilder: (context, index) {
                  return Text(
                    "- ${preScreenQuestion[index]} : ${preScreenAnswer[index]}",
                    style: TextStyle(fontSize: 16),
                  );
                },
              )
            else
              Text(
                "No pre-screen questions available.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              height: 40,
            ),
            Text(
              "Skills",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF202855),
              ),
            ),
            Gap(20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: skills
                  .map((skill) => Chip(
                        label: Text(skill),
                      ))
                  .toList(),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              height: 40,
            ),
            Text(
              "Portfolio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF202855),
              ),
            ),
            Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Replace with your function to open the PDF
                    print("Open PDF");
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
                    'assets/pdf/portfolio.pdf',
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                    onDocumentLoaded: (details) => print('Document loaded'),
                    onDocumentLoadFailed: (details) =>
                        print('Document failed to load'),
                  ),
                ),
              ],
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
