// profile_header.dart
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/write_screen.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:huzzl_web/views/recruiters/company_profile/widgets/edit_button.dart';
import 'package:provider/provider.dart';

class ProfileHeaderJobSeeker extends StatefulWidget {
  final String recruiterId;
  final bool showReviewBtn;
  const ProfileHeaderJobSeeker(
      {super.key, required this.recruiterId, required this.showReviewBtn});
  @override
  State<ProfileHeaderJobSeeker> createState() => _ProfileHeaderJobSeekerState();
}

class _ProfileHeaderJobSeekerState extends State<ProfileHeaderJobSeeker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProfileProvider>(
        builder: (context, provider, child) {
      return Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/banner.png',
                  height: 180.0,
                  width: 820,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -70,
                  left: 40,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage:
                          AssetImage('assets/images/profile_huzzl.png'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -70,
                  left: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            provider.companyName,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.bold,
                              color: Color(0xff202855),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(
                            provider.reviewStarsAverage.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 410),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 600.0), // Add padding here
              // child: SizedBox(height: 50,),
              child: SizedBox(
                width: 160,
                child: widget.showReviewBtn == false
                    ? SizedBox(
                        height: 50,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WriteReviewPage(
                                recruiterId: widget.recruiterId,
                                showReviewBtn: widget.showReviewBtn,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side:
                              BorderSide(color: Color(0xFF0038FF), width: 1.5),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Write a Review',
                          style: TextStyle(
                            color: Color(0xFF0038FF),
                            fontFamily: 'Galano',
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      );
    });
  }
}
