import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForReviewCard extends StatelessWidget {
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
                // Profile Image
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(
                      'assets/images/pfp.png'), // Assuming 'pfp.png' is inside your 'assets' folder
                ),
                SizedBox(width: 12),

                // Name, Job, Branch Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      'Eleanor Pena',
                      style: TextStyle(
                        fontFamily: 'Galano', // Custom font family
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Job Title
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

                    // Branch Info
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

            // Right section (Date and Button)
            Row(
              children: [
                // Date
                Text(
                  '05 Jul 2024',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Gap(100),

                // Review application button
                TextButton(
                  onPressed: () {},
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
                      color: Colors.blue, // Text color for the button
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
