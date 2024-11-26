import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/feedback_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/application_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/back_for_review_confirm_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/mark_as_done_confirm_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/reschedule_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/buttons.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/date_container.dart';
import 'package:intl/intl.dart';

class PastInterviewTileCard extends StatefulWidget {
  final String intervieweeName;
  final String interviewTitle;
  final String profession;
  final String branch;
  final DateTime dateInterviewed;

  const PastInterviewTileCard({
    super.key,
    required this.intervieweeName,
    required this.interviewTitle,
    required this.profession,
    required this.branch,
    required this.dateInterviewed,
  });

  @override
  State<PastInterviewTileCard> createState() => _PastInterviewTileCardState();
}

class _PastInterviewTileCardState extends State<PastInterviewTileCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate =
        DateFormat('dd MMM yyyy, h:mm a').format(widget.dateInterviewed);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // cursor: SystemMouseCursors.click,
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
      child: GestureDetector(
        onTap: () {},
        child: Card(
          // elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _isHovered ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Interview info
                Row(
                  children: [
                    //====================== Circle Avatar ======================
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xffd1e1ff),
                          foregroundColor: const Color(0xff373030),
                          child: Text(widget.intervieweeName[0]),
                        ),
                      ],
                    ),
                    const Gap(15),
                    //====================== Interviewee Details ======================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Interviewee name
                        Text(
                          widget.intervieweeName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff373030),
                          ),
                        ),
                        const SizedBox(height: 4),
                        //====================== Profession ======================
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              widget.profession,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        //====================== Branch applied ======================
                        Row(
                          children: [
                            const Icon(Icons.business_center_outlined,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              widget.branch,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                //====================== Interview title ======================
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.interviewTitle,
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            decorationColor: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff373030),
                          ),
                        ),
                      ],
                    ),
                    const Gap(200),
                    //Date interviewed
                    Row(
                      children: [
                        DateContainer(
                          date: formattedDate,
                          backgroundColor: const Color(0xffFFE0C3),
                          outlineBorderColor: const Color(0XFFFD7206),
                        ),
                      ],
                    ),
                    const Gap(100),
                    //Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                          color: const Color(0xff3B7DFF),
                        ),
                        const Gap(50),
                        IconButton(
                          onPressed: () async {
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;

                            final position = button.localToGlobal(Offset.zero,
                                ancestor: overlay);

                            await showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                position.dx,
                                position.dy,
                                overlay.size.width -
                                    position.dx -
                                    button.size.width,
                                overlay.size.height - position.dy,
                              ),
                              items: [
                                const PopupMenuItem(
                                  value: 'view_feedback',
                                  child: Row(
                                    children: [
                                      Icon(Icons.feedback_outlined, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('View feedback'),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((value) {
                              if (value == 'view_feedback') {
                                showFeedbackViewDialog(context, this);
                              }
                            });
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
