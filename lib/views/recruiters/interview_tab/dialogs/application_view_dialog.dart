import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/application_notes.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/resume_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationNotesDialog extends StatefulWidget {
  final TickerProvider vsync;

  ApplicationNotesDialog({required this.vsync});

  @override
  _ApplicationNotesDialogState createState() => _ApplicationNotesDialogState();
}

class _ApplicationNotesDialogState extends State<ApplicationNotesDialog>
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
              const Row(
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
                      Text(
                        'Application Date: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '05 July 2024, 8:42pm',
                        style: TextStyle(
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
                      const Text(
                        'Eleanor Pena',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _launchEmail,
                          child: const Text(
                            'eleanorpena@gmail.com',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFff9800),
                              color: Color(0xFFff9800),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Vocalist',
                        style: TextStyle(
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
                  Tab(text: 'Application Notes'),
                  Tab(text: 'Application'),
                  Tab(text: 'Resume'),
                ],
                views: [
                  ApplicationNotes(),
                  InterviewApplicationView(),
                  InterviewResumeView(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showApplicationNotesViewDialog(
    BuildContext context, TickerProvider vsync) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return ApplicationNotesDialog(vsync: vsync);
    },
  );
}
