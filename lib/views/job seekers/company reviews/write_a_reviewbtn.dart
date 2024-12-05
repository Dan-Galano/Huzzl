// edit_button.dart
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/write_screen.dart';

class WriteAReviewbtn extends StatelessWidget {
  final String compId;
  final String compName;
  const WriteAReviewbtn(
      {Key? key, required this.compId, required this.compName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          // WRITE A REVIEW BUTTON
          print("==company id: ${compId}");
          print("==comp name ${compName}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteReviewPage(
                companyId: compId,
                companyName: compName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Color(0xFF0038FF), width: 1.5),
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          'Write a review',
          style: TextStyle(
            color: Color(0xFF0038FF),
            fontFamily: 'Galano',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
