import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EditJobDetails extends StatefulWidget {
  final VoidCallback submitForm;
  final VoidCallback previousPage;
  String jobTitleController;
  String industry; // one or more
  String numOfPeopleToHire; // one or more
  String numPeople; // 1 to 10+
  final String branch;
  final TextEditingController jobDescriptionController;
  final String jobType;
  final String schedule;
  final List<String> skills;
  final List<String> responsibilities;
  final String selectedRate;
  final TextEditingController minRate;
  final TextEditingController maxRate;
  final List<String> supplementalPay;
  final String resumeRequiredAns;
  final String appDeadlineAns;
  DateTime appDeadlineDate;
  // final String hiringTimeline;
  final List<String> prescreenQuestions;
  final User user;
  final Map<String, dynamic> userData;

  EditJobDetails({
    super.key,
    required this.submitForm,
    required this.previousPage,
    required this.jobTitleController,
    required this.industry,
    required this.numOfPeopleToHire,
    required this.numPeople,
    required this.branch,
    required this.jobDescriptionController,
    required this.jobType,
    required this.schedule,
    required this.skills,
    required this.responsibilities,
    required this.selectedRate,
    required this.minRate,
    required this.maxRate,
    required this.supplementalPay,
    required this.resumeRequiredAns,
    required this.appDeadlineAns,
    required this.appDeadlineDate,
    // required this.hiringTimeline,
    required this.prescreenQuestions,
    required this.user,
    required this.userData,
  });

  @override
  State<EditJobDetails> createState() => _EditJobDetailsState();
}

class _EditJobDetailsState extends State<EditJobDetails> {
  final _formKey = GlobalKey<FormState>();

  // samples
  late TextEditingController jobTitleControllerTemp =
      TextEditingController(text: widget.jobTitleController);
  late TextEditingController industryController =
      TextEditingController(text: widget.industry);
  late TextEditingController jobDescriptionController =
      TextEditingController(text: widget.jobDescriptionController.text);

  late TextEditingController openingsController = TextEditingController(
      text: widget.numOfPeopleToHire == 'More than one person'
          ? widget.numPeople
          : widget.numOfPeopleToHire);
  late TextEditingController locationController =
      TextEditingController(text: '${widget.branch}');
  late TextEditingController jobTypeController =
      TextEditingController(text: widget.jobType);
  late TextEditingController scheduleController =
      TextEditingController(text: widget.schedule);
  late TextEditingController skillController =
      TextEditingController(text: widget.skills.join(', '));
  late TextEditingController responsibilitiesController =
      TextEditingController(text: widget.responsibilities.join(', '));

  late TextEditingController payController = TextEditingController(
      text: widget.selectedRate.isNotEmpty
          ? 'From ₱${widget.minRate.text} to ₱${widget.maxRate.text} ${widget.selectedRate}'
          : 'Pay not specified');
  late TextEditingController supplementalPayController = TextEditingController(
      text: widget.supplementalPay.isNotEmpty
          ? widget.supplementalPay.join(', ')
          : 'None');
  late TextEditingController requireResumeController =
      TextEditingController(text: widget.resumeRequiredAns);
  // late TextEditingController hiringTimelineController =
  //     TextEditingController(text: widget.hiringTimeline);
  late TextEditingController applicationDeadlineController =
      TextEditingController(
          text: widget.appDeadlineAns == 'Yes'
              ? DateFormat.yMMMd().format(widget.appDeadlineDate)
              : 'No Deadline');
  final TextEditingController updatesController =
      TextEditingController(text: 'huzzle@gmail.com'); // change this
  late TextEditingController preScreeningController = TextEditingController(
      text: widget.prescreenQuestions.isNotEmpty
          ? widget.prescreenQuestions.join(', ')
          : 'None');

  //Get current date
  String formattedCurrentDate = DateFormat.yMMMd().format(DateTime.now());

void _submitJobPost() {
  // Submit the job post form
  widget.submitForm();

  print("Job Title: ${jobTitleControllerTemp.text}");
  print("Job Industry: ${industryController.text}");
  print("Job Description: ${jobDescriptionController.text}");
  print("Job Type: ${jobTypeController.text}");
  print("Job Location: ${locationController.text}");

  FirebaseFirestore.instance
      .collection('users')
      .doc(widget.user.uid) // UID of the user
      .collection('job_posts')
      .add({
    'jobTitle': jobTitleControllerTemp.text,
    'jobIndustry': industryController.text,
    'jobDescription': jobDescriptionController.text,
    'numberOfPeopleToHire': openingsController.text,
    'jobPostLocation': locationController.text,
    'jobType': jobTypeController.text,
    'hoursPerWeek': scheduleController.text,
    'skills': skillController.text,
    'payRate': payController.text,
    'supplementalPay': supplementalPayController.text,
    'isResumeRequired': requireResumeController.text,
    'applicationDeadline': applicationDeadlineController.text,
    'updatesController': updatesController.text,
    'preScreenQuestions': widget.prescreenQuestions,
    'status': "open",
    'posted_at': formattedCurrentDate,
    'posted_by':
        '${widget.userData['hiringManagerFirstName']} ${widget.userData['hiringManagerLastName']}',
  }).then((docRef) {
    // Add the document ID to the job post
    docRef.update({
      'jobPostID': docRef.id,
    }).then((_) {
      print('Job post added successfully with ID: ${docRef.id}');

      // Update or increment the jobPostCount field in the user's document
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
            'jobPostsCount': FieldValue.increment(1), // Increment by 1
          })
          .then((_) => print('jobPostCount updated successfully'))
          .catchError((error) => print('Error updating jobPostCount: $error'));
    }).catchError((error) {
      print('Error updating job post with ID: $error');
    });
  }).catchError((error) {
    print('Error adding job post: $error');
  });
}



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Gap(20),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButton(
                onPressed: widget.previousPage,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFE9703),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 630,
              child: const Text(
                'Job Details',
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff202855),
                ),
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 630,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildJobDetailRow('Job title', jobTitleControllerTemp),
                        const Gap(10),
                        _buildJobDetailRow('Job industry', industryController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Number of openings', openingsController),
                        const Gap(10),
                        _buildJobDetailRow('Location', locationController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Description', jobDescriptionController),
                        const Gap(10),
                        _buildJobDetailRow('Job type', jobTypeController),
                        const Gap(10),
                        _buildJobDetailRow('Schedule', scheduleController),
                        const Gap(10),
                        _buildJobDetailRow('Skill', skillController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Responsibilities', responsibilitiesController),
                        const Gap(10),
                        _buildJobDetailRow('Pay', payController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Supplemental Pay', supplementalPayController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Require resume', requireResumeController),
                        // const Gap(10),
                        // _buildJobDetailRow(
                        //     'Hiring timeline', hiringTimelineController),
                        const Gap(10),
                        _buildJobDetailRow('Application deadline',
                            applicationDeadlineController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Application updates', updatesController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Customized pre-screening', preScreeningController),
                        const Gap(30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => _submitJobPost(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0038FF),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              child: Row(
                                children: const [
                                  Gap(5),
                                  Text(
                                    'Finish',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Galano',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Gap(10),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff202855),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle edit action
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.blueAccent,
            size: 20,
          ),
        ),
      ],
    );
  }
}
