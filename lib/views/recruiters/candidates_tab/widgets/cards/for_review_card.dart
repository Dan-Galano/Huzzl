import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_screen.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';

class ForReviewCard extends StatefulWidget {
  @override
  State<ForReviewCard> createState() => _ForReviewCardState();
}

class _ForReviewCardState extends State<ForReviewCard> {
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
        child: AnimatedContainer(
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
                    '10 Jul 2024, 5:38pm',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Gap(100),
              TextButton(
  onPressed: () {
    final homeState = context.findAncestorStateOfType<RecruiterHomeScreenState>();
    homeState?.toggleApplicationScreen(true);
  },
  style: TextButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    backgroundColor: Colors.blue.shade50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text(
    'Review application',
    style: TextStyle(
      fontFamily: 'Galano',
      fontSize: 14,
      color: Colors.blue,
    ),
  ),
),
   ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
