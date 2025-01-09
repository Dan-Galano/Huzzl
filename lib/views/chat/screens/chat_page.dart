import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/chat/components/chat_bubble.dart';
import 'package:huzzl_web/views/chat/services/chat_provider.dart';
import 'package:huzzl_web/views/chat/services/chat_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../../recruiters/branches_tab og/widgets/textfield_decorations.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String receiverEmail;
  final String receiverID;
  final SizingInformation sizeInfo;

  ChatPage(
      {super.key,
      required this.receiverEmail,
      required this.receiverID,
      required this.userData,
      required this.sizeInfo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  // final AuthService authService = AuthService();
  FirebaseAuth _auth = FirebaseAuth.instance;

  FocusNode myFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    resetUnreadCount();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(seconds: 1), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    resetUnreadCount();
    super.dispose();
  }

  void resetUnreadCount() {}

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Gap(10),
              CircleAvatar(
                radius: widget.sizeInfo.isDesktop ? 25 : 15,
                backgroundColor: Color(0xFFff9800).withOpacity(0.3),
                child: ((widget.userData["firstName"]?.isNotEmpty == true &&
                            widget.userData["lastName"]?.isNotEmpty == true) ||
                        (widget.userData["hiringManagerFirstName"]
                                    ?.isNotEmpty ==
                                true &&
                            widget.userData["hiringManagerLastName"]
                                    ?.isNotEmpty ==
                                true))
                    ? Text(
                        // Check for first name/last name or hiring manager's first and last name
                        "${(widget.userData["firstName"] ?? widget.userData["hiringManagerFirstName"] ?? '').toUpperCase()[0]}${(widget.userData["lastName"] ?? widget.userData["hiringManagerLastName"] ?? '').toUpperCase()[0]}",
                        style: TextStyle(
                          color: Color(0xFFfd7206),
                          fontSize: widget.sizeInfo.isDesktop ? 16 : 12,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: widget.sizeInfo.isDesktop ? 16 : 14,
                        color: Color(0xFFfd7206),
                      ),
              ),
              Gap(15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Display full name with fallback to hiring manager name if necessary
                    "${(widget.userData["firstName"] ?? widget.userData["hiringManagerFirstName"] ?? '')} ${(widget.userData["lastName"] ?? widget.userData["hiringManagerLastName"] ?? '')}",
                    style: TextStyle(
                      fontSize: widget.sizeInfo.isDesktop ? 16 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    // Display full name with fallback to hiring manager name if necessary
                    "${widget.userData["email"]}",
                    style: TextStyle(
                        fontSize: widget.sizeInfo.isDesktop ? 12 : 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ],
              ),
              Gap(20),
            ],
          ),
          Gap(30),
          Expanded(child: _buildMessageList(widget.sizeInfo)),
          buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList(SizingInformation sizeInfo) {
    String senderID = getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(radius: 15),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 80,
                        width: sizeInfo.isDesktop
                            ? MediaQuery.of(context).size.width * 0.30
                            : MediaQuery.of(context).size.width * 0.20,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(radius: 15),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.10,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(radius: 15),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.30,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(radius: 15),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 100,
                        width: sizeInfo.isDesktop
                            ? MediaQuery.of(context).size.width * 0.20
                            : MediaQuery.of(context).size.width * 0.40,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No data available.");
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

Widget _buildMessageItem(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool isCurrentUser = data["senderID"] == getCurrentUser()!.uid;

  // Assuming "timestamp" is a Firestore Timestamp
  Timestamp timestamp = data["timestamp"]; // Get the Timestamp object

  return Row(
    mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (!isCurrentUser) ...[
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
          child: ((widget.userData["firstName"]?.isNotEmpty == true &&
                      widget.userData["lastName"]?.isNotEmpty == true) ||
                  (widget.userData["hiringManagerFirstName"]?.isNotEmpty == true &&
                      widget.userData["hiringManagerLastName"]?.isNotEmpty == true))
              ? Text(
                  // Check for first name/last name or hiring manager's first and last name
                  "${(widget.userData["firstName"] ?? widget.userData["hiringManagerFirstName"] ?? '').toUpperCase()[0]}${(widget.userData["lastName"] ?? widget.userData["hiringManagerLastName"] ?? '').toUpperCase()[0]}",
                  style: TextStyle(color: Colors.white),
                )
              : Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
      ],
      Expanded(
        child: Align(
          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ChatBubble(
            timestamp: timestamp, // Pass the Timestamp directly
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ),
      ),
    ],
  );
}


  Widget buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          maxLines: 5,
          minLines: 1,
          controller: _messageController,
          focusNode: myFocusNode,
          textInputAction: TextInputAction.send,
          decoration: inputTextFieldDecoration(1, "Type a message..."),
          onSubmitted: (value) {
            _chatService.sendMessage(
                widget.receiverID, _messageController.text);
            _messageController.clear();
            scrollDown();
          },
        )),
        IconButton(
            onPressed: () {
              _chatService.sendMessage(
                  widget.receiverID, _messageController.text);
              _messageController.clear();
              scrollDown();
            },
            icon: Icon(
              Icons.send_rounded,
              color: Color(0xFF0084f6),
            ))
      ],
    );
  }
}
