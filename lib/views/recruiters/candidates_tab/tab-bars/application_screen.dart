import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/resume_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/shorlist_confirmation_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
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

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'eleanorpena@gmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   style: TextButton.styleFrom(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 54, vertical: 8),
                                  //     backgroundColor: const Color(0xFF3b7dff),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(8),
                                  //     ),
                                  //   ),
                                  //   child: Row(
                                  //     children: [
                                  //       Image.asset(
                                  //         "assets/images/msg-white-icon.png",
                                  //         width: 14,
                                  //       ),
                                  //       const Gap(10),
                                  //       const Text(
                                  //         'Message',
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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
                          height: 430,
                          width: double.infinity,
                          child: TextField(
                            controller: TextEditingController(
                              text:
                                  "Strong communication and problem-solving skills stand out.",
                            ),
                            maxLines: 20,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
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
