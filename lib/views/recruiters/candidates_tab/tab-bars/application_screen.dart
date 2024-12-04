import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/resume_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/shorlist_confirmation_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String candidateId;
  const ApplicationScreen({
    Key? key,
    required this.onBack,
    required this.candidateId,
  }) : super(key: key);

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _notesController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
    _notesController = TextEditingController(); // Initialize empty controller

    _fetchCandidateData();
  }

  Future<void> _fetchCandidateData() async {
    final jobCandidateProvider =
        Provider.of<JobProviderCandidate>(context, listen: false);
    final userId =
        Provider.of<UserProvider>(context, listen: false).loggedInUserId!;
    final jobPostId = jobCandidateProvider
            .findDataOfCandidate(widget.candidateId)
            ?.jobPostId ??
        '';
    final candidateId = widget.candidateId;

    if (userId.isNotEmpty && jobPostId.isNotEmpty && candidateId.isNotEmpty) {
      final notes = await jobCandidateProvider.fetchCurrentApplicationNotes(
          userId, jobPostId, candidateId);
      setState(() {
        _notesController.text =
            notes; // Set the fetched notes into the controller
        _isLoading = false; // Data has been loaded
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose(); // Dispose the controller
    _tabController.dispose();
    super.dispose();
  }

  void _launchEmail() async {
    var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: jobCandidateProvider.findDataOfCandidate(widget.candidateId)!.email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
    DateTime applicationDate = jobCandidateProvider
        .findDataOfCandidate(widget.candidateId)!
        .applicationDate;
    String formattedDate =
        jobCandidateProvider.formatApplicationDate(applicationDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: widget.onBack,
          label: const Text(
            "Back",
            style: TextStyle(color: Color(0xFFff9800), fontFamily: 'Galano'),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFff9800),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/pfp.png'),
                              ),
                              const Gap(15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Application Date: '),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Text(
                                    jobCandidateProvider
                                        .findDataOfCandidate(
                                            widget.candidateId)!
                                        .name,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: _launchEmail,
                                      child: Text(
                                        jobCandidateProvider
                                            .findDataOfCandidate(
                                                widget.candidateId)!
                                            .email,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFFff9800),
                                          color: Color(0xFFff9800),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    jobCandidateProvider
                                        .findDataOfCandidate(
                                            widget.candidateId)!
                                        .profession,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      minWidth: 80,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Status: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            jobCandidateProvider
                                                .findDataOfCandidate(
                                                    widget.candidateId)!
                                                .status,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.lock,
                                        size: 16,
                                      ),
                                      Gap(10),
                                      Text(
                                        "Interested?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  TextButton(
                                    onPressed: () =>
                                        showShortlistConfirmationDialog(
                                      context,
                                      jobCandidateProvider
                                          .findDataOfCandidate(
                                              widget.candidateId)!
                                          .jobPostId,
                                      widget.candidateId,
                                      jobCandidateProvider
                                          .findDataOfCandidate(
                                              widget.candidateId)!
                                          .jobApplicationDocId!,
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 8),
                                      backgroundColor: const Color.fromARGB(
                                          255, 182, 255, 194),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Move to Shortlisted',
                                      style: TextStyle(
                                        color: Color(0xFF157925),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextButton(
                                    onPressed: () {
                                      showRejectDialog(
                                          context, widget.candidateId);
                                      if (jobCandidateProvider.rejectMessage !=
                                          "") {
                                        jobCandidateProvider
                                            .clearMessage("Reject");
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 75, vertical: 8),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 209, 209),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: Color(0xFFd74a4a),
                                      ),
                                    ),
                                  ),
                                  const Gap(30),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 54, vertical: 8),
                                      backgroundColor: const Color(0xFF3b7dff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/msg-white-icon.png",
                                          width: 14,
                                        ),
                                        const Gap(10),
                                        const Text(
                                          'Message',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(30),
                          TabBarInside(
                            tabController: _tabController,
                            tabs: const [
                              Tab(text: 'Application'),
                              Tab(text: 'Resume'),
                            ],
                            views: [
                              ApplicationView(
                                jobPostId: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobPostId,
                                jobSeekerId: widget.candidateId,
                                jobApplication: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobApplicationDocId!,
                              ),
                              ResumeView(
                                jobPostId: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobPostId,
                                jobSeekerId: widget.candidateId,
                                jobApplication: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobApplicationDocId!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.lock,
                              size: 16,
                            ),
                            Gap(10),
                            Text(
                              "Notes",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(20),
                            Text(
                              "Only visible to the team",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Container(
                          height: 530,
                          width: double.infinity,
                          child: TextField(
                            controller: _notesController,
                            maxLines: 20,
                            decoration: const InputDecoration(
                              hintText:
                                  "Add your comments or feedback here. Consider the applicant's qualifications, experience, and overall fit for the role.",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              // Optional: Update state if needed to reflect changes dynamically
                            },
                          ),
                        ),
                        Gap(20),
                        Row(
                          children: [
                            Expanded(
                              child: BlueFilledCircleButton(
                                onPressed: () async {
                                  final String userId =
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .loggedInUserId!;
                                  final String jobPostId = jobCandidateProvider
                                      .findDataOfCandidate(widget.candidateId)!
                                      .jobPostId!;
                                  final String candidateId = widget.candidateId;

                                  // Debugging: Check the values before saving
                                  print("User ID: $userId");
                                  print("Job Post ID: $jobPostId");
                                  print("Candidate ID: $candidateId");
                                  print("Notes: ${_notesController.text}");

                                  try {
                                    // Construct the Firestore document path
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .collection('job_posts')
                                        .doc(jobPostId)
                                        .collection('candidates')
                                        .doc(candidateId)
                                        .set({
                                      'applicationNotes': _notesController.text
                                          .trim(), //but when i do this fpr debugging, it saves this. so the prob is in controller
                                    }, SetOptions(merge: true));

                                    // Provide feedback
                                    EasyLoading.instance
                                      ..displayDuration =
                                          const Duration(milliseconds: 1500)
                                      ..indicatorType =
                                          EasyLoadingIndicatorType.fadingCircle
                                      ..loadingStyle = EasyLoadingStyle.custom
                                      ..backgroundColor =
                                          const Color.fromARGB(255, 38, 135, 57)
                                      ..textColor = Colors.white
                                      ..fontSize = 16.0
                                      ..indicatorColor = Colors.white
                                      ..maskColor =
                                          Colors.black.withOpacity(0.5)
                                      ..userInteractions = false
                                      ..dismissOnTap = true;
                                    EasyLoading.showToast(
                                      "✓ Notes saved.",
                                      dismissOnTap: true,
                                      toastPosition:
                                          EasyLoadingToastPosition.top,
                                      duration: Duration(seconds: 3),
                                    );
                                  } catch (e) {
                                    // Handle errors
                                    print("Error saving notes: $e");
                                    EasyLoading.instance
                                      ..displayDuration =
                                          const Duration(milliseconds: 1500)
                                      ..indicatorType =
                                          EasyLoadingIndicatorType.fadingCircle
                                      ..loadingStyle = EasyLoadingStyle.custom
                                      ..backgroundColor =
                                          const Color(0xFfd74a4a)
                                      ..textColor = Colors.white
                                      ..fontSize = 16.0
                                      ..indicatorColor = Colors.white
                                      ..maskColor =
                                          Colors.black.withOpacity(0.5)
                                      ..userInteractions = false
                                      ..dismissOnTap = true;
                                    EasyLoading.showToast(
                                      "⚠︎ Failed to save notes",
                                      dismissOnTap: true,
                                      toastPosition:
                                          EasyLoadingToastPosition.top,
                                      duration: Duration(seconds: 3),
                                      // maskType: EasyLoadingMaskType.black,
                                    );
                                  }
                                },
                                text: "Save Notes",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
