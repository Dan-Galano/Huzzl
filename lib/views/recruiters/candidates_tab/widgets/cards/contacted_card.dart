import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/hiring_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/feedback_view_dialog.dart';

class ContactedCard extends StatefulWidget {
  @override
  State<ContactedCard> createState() => _ContactedCardState();
}

class _ContactedCardState extends State<ContactedCard> with TickerProviderStateMixin {
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
                      Text(
                        '3',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Gap(90),
                      Text(
                        '14 Jul 2024, 8:00am',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Gap(90),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/images/chat-icon-recruiter.png',
                            width: 20),
                      ),
                      Gap(40),
                      TextButton(
                        onPressed: () => showHiringDialog(context),
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          backgroundColor: const Color(0xFF358742),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Hire',
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      Gap(20),
                      TextButton(
                        onPressed: () => showRejectDialog(context),
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          backgroundColor: const Color(0xFFd74a4a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      // Gap(20),
                      // TextButton(
                      //   onPressed: () {},
                      //   style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      //     backgroundColor: const Color(0xFF3b7dff),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     'Reserve',
                      //     style: TextStyle(
                      //       fontFamily: 'Galano',
                      //       fontSize: 14,
                      //       color: Color.fromARGB(255, 255, 255, 255),
                      //     ),
                      //   ),
                      // ),
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
                    items: [ PopupMenuItem(
                        value: 'view_previous_feedback',
                        child: Row(
                          children: [
                            Icon(Icons.feedback_outlined,
                                color: Colors.grey),
                            SizedBox(width: 8),Text('View Feedback'),],),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'view_previous_feedback') {
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
