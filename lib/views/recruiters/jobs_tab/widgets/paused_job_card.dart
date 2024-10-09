import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PausedJobCard extends StatefulWidget {
  PausedJobCard({super.key});

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
                  SizedBox(width: 12),

                  // Name, Job, Branch Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        'Need Vocalist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // SizedBox(height: 4),
                      Text(
                        'January 18, 2024 at Brgy. Moreno, Binalonan, Pangasinan',
                        style: TextStyle(
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
                  textLists("Part-time"),
                  Gap(60),
                  textLists("Juan Cruz"),
                  Gap(70),
                  Text(
                    '1 applied',
                    style: TextStyle(fontSize: 12, color: Color(0xff3B7DFF)),
                  ),
                  Gap(60),
                  textLists("05/12/2024"),
                  Gap(60),
                  IconButton(
                    onPressed: () {},
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

  Text textLists(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
