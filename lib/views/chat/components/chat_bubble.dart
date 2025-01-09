import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for Timestamp handling

class ChatBubble extends StatelessWidget {
  final Timestamp timestamp; // Accept Timestamp type for timeSent
  final String message;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Convert the Timestamp to DateTime
    DateTime timeSentDateTime = timestamp.toDate();

    // Format the timeSent
    String formattedTime = (DateTime.now()
                .difference(timeSentDateTime)
                .inDays <=
            7)
        ? '${DateFormat('EEE').format(timeSentDateTime)} at ${DateFormat('hh:mma').format(timeSentDateTime)}'
        : '${DateFormat('MMM dd, yyyy').format(timeSentDateTime)} at ${DateFormat('hh:mma').format(timeSentDateTime)}';

    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser ? Color(0xFF0084f6) : Colors.grey[500],
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: isCurrentUser ? screenWidth * 0.25 : 5,
          right: isCurrentUser ? 25 : screenWidth * 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 4), // Add some space between the message and time
          Text(
            formattedTime,
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.7), // Lighter color for the time
              fontStyle: FontStyle.italic,
              fontSize: 10, // Smaller font size
            ),
          ),
        ],
      ),
    );
  }
}
