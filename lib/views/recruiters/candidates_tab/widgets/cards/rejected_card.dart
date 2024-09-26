import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/movetoReserved_confirm_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/feedback_view_dialog.dart';

class RejectedCard extends StatefulWidget {
  @override
  State<RejectedCard> createState() => _RejectedCardState();
}

class _RejectedCardState extends State<RejectedCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
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
                            'Eleanor Pena',
                            style: TextStyle(
                              fontFamily: 'Galano',
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
                                'Vocalist',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.home, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                'Urdaneta Branch',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/images/chat-icon-recruiter.png',
                            width: 20),
                      ),
                      Gap(40),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(69, 215, 74, 74),
                          border: Border.all(color: Color(0xFFd74a4a)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Rejected on July 23, 2024",
                          style: TextStyle(
                            color: Color(0xFFd74a4a),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
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
                      PopupMenuItem(
                        value: 'move_to_reserved',
                        child: Row(
                          children: [
                            Icon(Icons.drive_file_move_outlined,
                                color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Move to Reserved'),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'move_to_reserved') {
                      showMoveToReservedConfirmationDialog(context);
                    } else if (value == 'view_previous_feedback') {
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
