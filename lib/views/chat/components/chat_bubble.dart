import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
