import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/moveback_confirmation_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/resume_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/skillchip.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SlApplicationScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SlApplicationScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<SlApplicationScreen> createState() => _SlApplicationScreenState();
}

class _SlApplicationScreenState extends State<SlApplicationScreen>
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
                                    children: const [
                                      Text('Application Date: '),
                                      Text(
                                        '05 July 2024, 8:42pm',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
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
                                        children: const [
                                          Text("Status: "),
                                          Text(
                                            'Shortlisted',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
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
                                        moveBackToReviewDialog(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 8),
                                      backgroundColor:
                                          Color.fromARGB(255, 226, 226, 226),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Move back to "For Review"',
                                      style: TextStyle(
                                        color: Color(0xFF424242),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextButton(
                                    onPressed: () => showRejectDialog(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 89, vertical: 8),
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
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(30),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 65, vertical: 8),
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
                                  Gap(10),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 29, vertical: 8),
                                      backgroundColor: const Color(0xFFfd7206),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const Gap(10),
                                        const Text(
                                          'Schedule interview',
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
                              ApplicationView(),
                              ResumeView(),
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
                              text: "Ok naman siya",
                            ),
                            maxLines: 20,
                            decoration: InputDecoration(
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
