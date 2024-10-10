import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PausedJobCard extends StatefulWidget {
  final String? jobTitle;
  final String? jobDeadline;
  final String? jobPostedAt;
  final String? jobPostedBy;
  final String? jobType;
  final int numberOfApplicants;
  const PausedJobCard(
      {super.key,
      this.jobTitle,
      this.jobPostedAt,
      this.jobPostedBy,
      this.jobType,
      required this.numberOfApplicants,
      this.jobDeadline});

  @override
  State<PausedJobCard> createState() => _PausedJobCardState();
}

class _PausedJobCardState extends State<PausedJobCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isHovered
                ? const Color.fromARGB(17, 121, 121, 121)
                : Colors.transparent,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left section (Profile Image, Name, Job, Branch)
              Row(
                children: [
                  Image.asset('assets/images/job-bag-icon.png'),
                  const SizedBox(width: 12),

                  // Name, Job, Branch Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        '${widget.jobTitle}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // SizedBox(height: 4),
                      Text(
                        'Paused on ${widget.jobDeadline}', //need pa palitan ng paused date talaga. currently: jobDeadline
                        style: const TextStyle(
                          // fontWeight: FontWeight.,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Right section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Date
                  textLists(widget.jobType!),
                  textLists(widget.jobPostedBy!),
                  blueTextList('${widget.numberOfApplicants} applied'),
                  textLists(widget.jobPostedAt!),

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
                            value: 'Re-open',
                            child: Row(
                              children: [
                                Icon(Icons.pause_circle_outline,
                                    color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Re-open'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'close',
                            child: Row(
                              children: [
                                Icon(Icons.stop_circle_outlined,
                                    color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Close'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_note_outlined,
                                    color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        ],
                      ).then((value) {
                        // if (value == 'move_back_for_review') {
                        //   moveBackToReviewDialog(context);
                        // }
                      });
                    },
                    icon: Image.asset(
                        'assets/images/three-dot-icon-data-table.png'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox textLists(String text) {
    return SizedBox(
      width: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  SizedBox blueTextList(String text) {
    return SizedBox(
      width: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xff3B7DFF)),
        ),
      ),
    );
  }
}
