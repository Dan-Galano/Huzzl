import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/views/feedback_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/hiring_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/evaluation_candidate_model.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContactedCard extends StatefulWidget {
  Candidate candidate;
  ContactedCard({super.key, required this.candidate});

  @override
  State<ContactedCard> createState() => _ContactedCardState();
}

class _ContactedCardState extends State<ContactedCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late InterviewProvider _interviewProvider;
  late EvaluatedCandidateModel _myLateEvaluatedCandidateModel;

  EvaluatedCandidateModel? _myEvaluatedCandidateModel;

  @override
  void initState() {
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);
    fetchEvaluation();
    super.initState();
  }

  void fetchEvaluation() async {
    _myLateEvaluatedCandidateModel =
        (await _interviewProvider.fetchEvaluationForJobseeker(
            widget.candidate.jobPostId,
            widget.candidate.jobApplicationDocId!))!;
    setState(() {
      _myEvaluatedCandidateModel = _myLateEvaluatedCandidateModel;
    });

    debugPrint("Fetch evaluated data");
  }

  void showEvaluationScores() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text(
                "Interview Evaluation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
            ],
          ),
          contentPadding: const EdgeInsets.all(30),
          actions: [
            BlueFilledBoxButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "OK",
            ),
          ],
          
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Points:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${_myEvaluatedCandidateModel!.totalPoints} / 100',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Evaluation Area/Aspect:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _myEvaluatedCandidateModel!.topEvaluationArea,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Evaluation:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _myEvaluatedCandidateModel!.evaluation,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: int.parse(_myEvaluatedCandidateModel!
                                          .totalPoints) >=
                                      80
                                  ? Colors.green
                                  : int.parse(_myEvaluatedCandidateModel!
                                              .totalPoints) >=
                                          60
                                      ? Colors.blue
                                      : int.parse(_myEvaluatedCandidateModel!
                                                  .totalPoints) >=
                                              40
                                          ? Colors.orange
                                          : Colors
                                              .red, // Color based on totalPoints
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      const Text(
                        'Comment:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        _myEvaluatedCandidateModel!.comment,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
    String date = DateFormat('d MMM yyyy, h:mma')
        .format(widget.candidate.dateLastInterviewed!);

    if (_myEvaluatedCandidateModel == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Color.fromARGB(17, 121, 121, 121)
                    : Colors.transparent,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/pfp.png'),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.candidate.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.badge, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                widget.candidate.profession,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          // Row(
                          //   children: [
                          //     Icon(Icons.home, size: 16, color: Colors.grey),
                          //     SizedBox(width: 4),
                          //     Text(
                          //       widget.candidate.companyAppliedTo,
                          //       style: TextStyle(
                          //         color: Colors.grey.shade500,
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          showEvaluationScores();
                        },
                        child: Text(
                          "${_myEvaluatedCandidateModel!.totalPoints} / 100",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Gap(90),
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Gap(90),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/images/chat-icon-recruiter.png',
                            width: 20),
                      ),
                      Gap(40),
                      TextButton(
                        onPressed: () {
                          showHiringDialog(context, widget.candidate.id);
                          jobCandidateProvider.clearMessage("Hire");
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          backgroundColor: const Color(0xFF358742),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Hire',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Gap(20),
                      TextButton(
                        // onPressed: () => showRejectDialog(context),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          backgroundColor: const Color(0xFFd74a4a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      // Gap(20),
                      // TextButton(
                      //   onPressed: () {},
                      //   style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      //     backgroundColor: const Color(0xFF3b7dff),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     'Reserve',
                      //     style: TextStyle(
                      //
                      //       fontSize: 14,
                      //       color: Color.fromARGB(255, 255, 255, 255),
                      //     ),
                      //   ),
                      // ),
                      Gap(40),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;

                  final position =
                      button.localToGlobal(Offset.zero, ancestor: overlay);
                  await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      overlay.size.width - position.dx - button.size.width,
                      overlay.size.height - position.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'view_previous_feedback',
                        child: Row(
                          children: [
                            Icon(Icons.feedback_outlined, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('View Feedback'),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'view_previous_feedback') {
                      showFeedbackViewDialog(context, this);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
