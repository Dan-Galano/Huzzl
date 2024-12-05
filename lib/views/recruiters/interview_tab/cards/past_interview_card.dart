import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/feedback_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/date_container.dart';
import 'package:intl/intl.dart';

class PastInterviewTileCard extends StatefulWidget {
  final InterviewEvent interview;

  const PastInterviewTileCard({super.key, required this.interview});

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
        DateFormat('dd MMM yyyy, h:mma').format(widget.interview.date!);
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
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xffd1e1ff),
                      foregroundColor: const Color(0xff373030),
                      child: Text(widget.interview.applicant![0]),
                    ),
                  ],
                ),
                const Gap(15),
                //====================== Interviewee Details ======================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Interviewee name
                      Text(
                        widget.interview.applicant!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff373030),
                        ),
                      ),
                      const SizedBox(height: 4),
                      //====================== Profession ======================
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            widget.interview.profession!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      //====================== Branch applied ======================
                      // Row(
                      //   children: [
                      //     const Icon(Icons.business_center_outlined,
                      //         size: 18, color: Colors.grey),
                      //     const SizedBox(width: 5),
                      //     Text(
                      //       widget.branch,
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                //====================== Interview title ======================
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.interview.title!,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff373030),
                        ),
                      ),
                      const Text(
                        "Title",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Galano',
                        ),
                      ),
                    ],
                  ),
                ),
                //Date interviewed
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Date Interviewed",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Galano',
                        ),
                      ),
                      const Gap(8),
                      DateContainer(
                        date: formattedDate,
                        backgroundColor: const Color(0xffFFE0C3),
                        outlineBorderColor: const Color(0XFFFD7206),
                      ),
                    ],
                  ),
                ),
                //Buttons
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.chat),
                //   color: const Color(0xff3B7DFF),
                // ),
                // IconButton(
                //   onPressed: () async {
                //     final RenderBox button =
                //         context.findRenderObject() as RenderBox;
                //     final RenderBox overlay = Overlay.of(context)
                //         .context
                //         .findRenderObject() as RenderBox;

                //     final position =
                //         button.localToGlobal(Offset.zero, ancestor: overlay);

                //     await showMenu(
                //       context: context,
                //       position: RelativeRect.fromLTRB(
                //         position.dx,
                //         position.dy,
                //         overlay.size.width - position.dx - button.size.width,
                //         overlay.size.height - position.dy,
                //       ),
                //       items: [
                //         const PopupMenuItem(
                //           value: 'view_feedback',
                //           child: Row(
                //             children: [
                //               Icon(Icons.feedback_outlined, color: Colors.grey),
                //               SizedBox(width: 8),
                //               Text('View feedback'),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ).then((value) {
                //       if (value == 'view_feedback') {
                //         showFeedbackViewDialog(context, this);
                //       }
                //     });
                //   },
                //   icon: const Icon(Icons.more_vert),
                // ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
