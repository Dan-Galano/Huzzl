import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OpenJobCard extends StatelessWidget {
  final String? jobTitle;
  final String? jobDeadline;
  final String? jobPostedAt;
  final String? jobType;
  const OpenJobCard({
    required this.jobTitle,
    required this.jobDeadline,
    required this.jobPostedAt,
    required this.jobType,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
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
                SizedBox(width: 12),

                // Name, Job, Branch Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      '$jobTitle',
                      style: TextStyle(
                        fontFamily: 'Galano', // Custom font family
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(height: 4),
                    Text(
                      '$jobDeadline',
                      style: TextStyle(
                        fontFamily: 'Galano', // Custom font family
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
              children: [
                // Date
                textLists(jobType!),
                Gap(60),
                textLists("Juan Cruz"),
                Gap(70),
                Text(
                  '1 applied',
                  style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 12,
                      color: Color(0xff3B7DFF)),
                ),
                Gap(60),
                textLists(jobPostedAt!),
                Gap(60),
                textLists("3 days left"),

                Gap(60),
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
                        PopupMenuItem(
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
                        PopupMenuItem(
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
                        PopupMenuItem(
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
    );
  }

  Text textLists(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Galano',
        fontSize: 12,
      ),
    );
  }
}
