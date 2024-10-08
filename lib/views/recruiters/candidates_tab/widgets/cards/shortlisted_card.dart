import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/moveback_confirmation_dialog.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';

class ShortListedCard extends StatefulWidget {
  @override
  State<ShortListedCard> createState() => _ShortListedCardState();
}

class _ShortListedCardState extends State<ShortListedCard> {
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
                        '14 Jul 2024, 8:00am',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Gap(100),
                      TextButton(
                        onPressed: () {
                          final homeState = context.findAncestorStateOfType<
                              RecruiterHomeScreenState>();
                          homeState?.toggleSlApplicationScreen(true, 1);
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'See application',
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 14,
                            color: Colors.blue,
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
                        value: 'move_back_for_review',
                        child: Row(
                          children: [
                            Icon(Icons.drive_file_move_rtl_outlined,
                                color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Move back to "For review"'),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'move_back_for_review') {
                      moveBackToReviewDialog(context);
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
