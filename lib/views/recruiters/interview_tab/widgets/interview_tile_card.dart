import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/widgets/buttons.dart';

class InterviewTile extends StatefulWidget {
  final String intervieweeName;
  final String profession;
  final String branch;
  final String interviewTitle;
  final String interviewType;

// intervieweeName
// profession
// branch?
// interviewTitle
//interviewType

  InterviewTile({
    required this.intervieweeName,
    required this.profession,
    required this.branch,
    required this.interviewTitle,
    required this.interviewType,
  });

  @override
  State<InterviewTile> createState() => _InterviewTileState();
}

class _InterviewTileState extends State<InterviewTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _isHovered ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Interview info
                Expanded(
                  child: Row(
                    children: [
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
                ),
                //Interview title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        widget.interviewType,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.orange,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat),
                        color: const Color(0xff3B7DFF),
                      ),
                      const Gap(50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.interviewType == 'Online') ...[
                            StartInterviewButton(
                              onPressed: () {},
                            ),
                            const Gap(10),
                          ],
                          ...[
                            MarkAsDoneButton(
                              onPressed: () {},
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Expanded(
                    flex: 0,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
