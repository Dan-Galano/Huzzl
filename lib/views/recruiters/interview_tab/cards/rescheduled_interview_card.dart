import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/application_view_dialog.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/date_container.dart';
import 'package:intl/intl.dart';

class RescheduledInterviewTileCard extends StatefulWidget {
  final String intervieweeName;
  final String interviewTitle;
  final String profession;
  final String branch;
  final DateTime formerDateInterviewed;
  final DateTime newDateInterviewed;

  const RescheduledInterviewTileCard({
    super.key,
    required this.intervieweeName,
    required this.interviewTitle,
    required this.profession,
    required this.branch,
    required this.formerDateInterviewed,
    required this.newDateInterviewed,
  });

  @override
  State<RescheduledInterviewTileCard> createState() =>
      _RescheduledInterviewTileCardState();
}

class _RescheduledInterviewTileCardState
    extends State<RescheduledInterviewTileCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  late String formerFormattedDate;
  late String newFormattedDate;

  @override
  void initState() {
    super.initState();
    formerFormattedDate =
        DateFormat('dd MMM yyyy, h:mm a').format(widget.formerDateInterviewed);
    newFormattedDate =
        DateFormat('dd MMM yyyy, h:mm a').format(widget.newDateInterviewed);
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
                        //Interviewee job
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
                        //Branch applied
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
                //Interview title
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
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
                    const Gap(50),
                    //Former interviewed date
                    Row(
                      children: [
                        DateContainer(
                          date: formerFormattedDate,
                          backgroundColor: const Color(0xffEAEAEA),
                          outlineBorderColor: const Color(0XFF616161),
                        ),
                      ],
                    ),
                    const Gap(50),
                    //New interviewed date
                    Row(
                      children: [
                        DateContainer(
                          date: newFormattedDate,
                          backgroundColor: const Color(0xffE4EDFF),
                          outlineBorderColor: const Color(0XFF3B7DFF),
                        ),
                      ],
                    ),
                    const Gap(50),
                    //Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                          color: const Color(0xff3B7DFF),
                        ),
                        const Gap(50),
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
