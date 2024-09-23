import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OpenJobCard extends StatelessWidget {
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
                      'Need Vocalist',
                      style: TextStyle(
                        fontFamily: 'Galano', // Custom font family
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(height: 4),
                    Text(
                      'January 18, 2024 at Brgy. Moreno, Binalonan, Pangasinan',
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
                textLists("Part-time"),
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
                textLists("05/12/2024"),
                Gap(60),
                textLists("3 days left"),

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
