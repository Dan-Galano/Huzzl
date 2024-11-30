import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/application_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/mark_as_done_confirm_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/mark_as_done_dialog%20copy.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/reschedule_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/buttons.dart';
import 'package:provider/provider.dart';

class UpcomingInterviewTile extends StatefulWidget {
  // final String intervieweeName;
  // final String profession;
  // // final String branch;
  // final String interviewTitle;
  // final String interviewType;
  // // final DateTimeRange timeRange;
  // final TimeOfDay startTime;
  // final TimeOfDay endTime;
  InterviewEvent interview;

// intervieweeName
// profession
// branch?
// interviewTitle
//in.terviewType

  UpcomingInterviewTile({super.key, required this.interview
      // required this.intervieweeName,
      // required this.profession,
      // // required this.branch,
      // required this.interviewTitle,
      // required this.interviewType,
      // // required this.timeRange,
      // required this.startTime,
      // required this.endTime,
      });

  @override
  State<UpcomingInterviewTile> createState() => _UpcomingInterviewTileState();
}

class _UpcomingInterviewTileState extends State<UpcomingInterviewTile>
    with TickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _isHovered ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
                      //Interviewee job
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
                      //Branch applied
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
                //Interview title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        widget.interview.type!,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.orange,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.chat),
                //   color: const Color(0xff3B7DFF),
                // ),
                const Gap(30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // if (widget.interview.type == 'Online') ...[
                      //   StartInterviewButton(
                      //     startTime:
                      //         widget.interview.startTime!,
                      //     endTime: widget.interview.endTime!,
                      //     onPressed: () {
                      //       // interviewProvider.updateInterviewStatus(widget.interview);
                      //       // debugPrint("Interview Status Changeee to Starteeeddd");
                      //       interviewProvider.startInterviewFunction(context, 'recruiter', e: widget.interview);
                      //       debugPrint("Video call started.....");
                      //     },
                      //   ),
                      //   const Gap(10),
                      // ],
                      // ...[
                      MarkAsDoneButton(
                        onPressed: () => showMarkAsDoneDialog(context),
                        // onPressed: (){},
                      ),
                      // ],
                    ],
                  ),
                ),
                IconButton(
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
                        const PopupMenuItem(
                          value: 'view_applicant_details',
                          child: Row(
                            children: [
                              Icon(Icons.file_open_outlined,
                                  color: Colors.grey),
                              SizedBox(width: 8),
                              Text('View applicant\'s details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reschedule_interview',
                          child: Row(
                            children: [
                              Icon(Icons.edit_calendar_outlined,
                                  color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Reschedule interview'),
                            ],
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value == 'view_applicant_details') {
                        showApplicationNotesViewDialog(context, this);
                      } else if (value == 'reschedule_interview') {
                        showRescheduleInterviewDialog(context);
                      }
                    });
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
