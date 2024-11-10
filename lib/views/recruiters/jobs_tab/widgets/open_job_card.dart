import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OpenJobCard extends StatefulWidget {
  final String? jobTitle;
  final String? jobDeadline;
  final String? jobPostedAt;
  final String? jobPostedBy;
  final String? jobType;
  final String? jobPostID;
  final int numberOfApplicants;
  final User user;
  const OpenJobCard({
    super.key,
    required this.jobTitle,
    required this.jobDeadline,
    required this.jobPostedAt,
    required this.jobPostedBy,
    required this.jobType,
    required this.jobPostID,
    required this.numberOfApplicants,
    required this.user,
  });

  @override
  State<OpenJobCard> createState() => _OpenJobCardState();
}

class _OpenJobCardState extends State<OpenJobCard> {
  bool isHovered = false;

  String getTimeLeftUntilDeadline(String deadline) {
    // Define the date format based on your deadline string
    final DateFormat formatter = DateFormat('MMM d, yyyy');

    // Parse the deadline string into a DateTime object
    DateTime deadlineDate = formatter.parse(deadline);

    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the difference between the deadline and the current date
    Duration difference = deadlineDate.difference(now);

    // Convert the difference to the number of days
    int daysLeft = difference.inDays;

    // Display the appropriate message based on how many days/weeks/months left
    if (daysLeft <= 0) {
      return "Deadline has passed"; // Deadline already passed
    } else if (daysLeft <= 6) {
      return "$daysLeft day${daysLeft > 1 ? 's' : ''} left"; // Less than a week
    } else if (daysLeft <= 27) {
      int weeksLeft = (daysLeft / 7).ceil(); // Calculate how many weeks left
      return "$weeksLeft week${weeksLeft > 1 ? 's' : ''} left";
    } else {
      // Handle months left (4 weeks = ~28 days, round to months)
      int monthsLeft = (daysLeft / 30).ceil(); // Approximate months left
      return "$monthsLeft month${monthsLeft > 1 ? 's' : ''} left";
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProviderCandidate>(context);
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
                        '${widget.jobDeadline}',
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
                  textLists(getTimeLeftUntilDeadline(widget.jobDeadline!)),

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
                            value: 'pause',
                            child: Row(
                              children: [
                                Icon(Icons.pause_circle_outline,
                                    color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Pause'),
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

                        if (value == "close") {
                          jobProvider.closeJobPost(
                              widget.user.uid, widget.jobPostID!);
                        } else if (value == "pause") {
                          jobProvider.pauseJobPost(
                              widget.user.uid, widget.jobPostID!);
                        }
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
