import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_notes.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/interview_feedback_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/resume_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/evaluation_candidate_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackDialog extends StatefulWidget {
  final TickerProvider vsync;
  final Candidate candidate;
  final EvaluatedCandidateModel evaluationDetails;
  FeedbackDialog({
    required this.vsync,
    required this.candidate,
    required this.evaluationDetails,
  });

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: widget.candidate.email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat("dd MMMM yyyy, h:mma").format(dateTime).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: widget.vsync);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      content: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Gap(3),
                      Text(
                        "View Only",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Application Date: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        formatDateTime(widget.candidate.applicationDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/pfp.png'),
                  ),
                  const Gap(15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.candidate.name,
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
                            widget.candidate.email,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFff9800),
                              color: Color(0xFFff9800),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.candidate.profession,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                ],
              ),
              Gap(20),
              TabBarInside(
                tabController: _tabController,
                tabs: const [
                  Tab(text: 'Interview Post-feedback'),
                  Tab(text: 'Application Notes'),
                  Tab(text: 'Application'),
                  Tab(text: 'Resume'),
                ],
                views: [
                  InterviewFeedbackView(
                    evaluationDetails: widget.evaluationDetails,
                  ),
                  ApplicationNotes(),
                  // ApplicationView(),
                  ResumeView(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFeedbackViewDialog(BuildContext context, TickerProvider vsync,
    Candidate candidate, EvaluatedCandidateModel evaluationDetails) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return FeedbackDialog(
        vsync: vsync,
        candidate: candidate,
        evaluationDetails: evaluationDetails,
      );
    },
  );
}
