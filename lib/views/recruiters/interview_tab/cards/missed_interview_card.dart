import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/mark_as_done_dialog%20copy.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/reschedule_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/buttons.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/date_container.dart';
import 'package:intl/intl.dart';

class MissedInterviewCard extends StatefulWidget {
  final String intervieweeName;
  final String interviewTitle;
  final String interviewType;
  final String profession;
  final String branch;
  final DateTime dateInterviewed;

  const MissedInterviewCard({
    super.key,
    required this.intervieweeName,
    required this.interviewTitle,
    required this.interviewType,
    required this.profession,
    required this.branch,
    required this.dateInterviewed,
  });

  @override
  State<MissedInterviewCard> createState() => _MissedInterviewCardState();
}

class _MissedInterviewCardState extends State<MissedInterviewCard>
    with TickerProviderStateMixin {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate =
        DateFormat('dd MMM yyyy, h:mm a').format(widget.dateInterviewed);
  }

  bool _isHovered = false;

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
                      child: Text(widget.intervieweeName[0]),
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
                        widget.intervieweeName,
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
                            widget.profession,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      //Branch applied
                      Row(
                        children: [
                          const Icon(Icons.business_center_outlined,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            widget.branch,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Interview title
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.interviewTitle,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.orange,
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
                const Gap(50),
                //interviewed date
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Interview Date",
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
                        backgroundColor: const Color(0xffFDE5E5),
                        outlineBorderColor: const Color(0xffD74A4A),
                      ),
                    ],
                  ),
                ),
                //Buttons
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat),
                    color: const Color(0xff3B7DFF),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RescheduleInterviewButton(
                        onPressed: () => showRescheduleInterviewDialog(context),
                      ),
                      const Gap(10),
                      MarkAsDoneButton(
                        onPressed: () => showMarkAsDoneDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
