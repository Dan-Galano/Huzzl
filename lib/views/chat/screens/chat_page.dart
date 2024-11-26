import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/chat/components/chat_bubble.dart';
import 'package:huzzl_web/views/chat/services/chat_provider.dart';
import 'package:huzzl_web/views/chat/services/chat_service.dart';
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
  late final ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

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
                // child: (widget.userData["hiringManagerFirstName"]?.isNotEmpty ==
                child: (widget.userData["firstName"]?.isNotEmpty ==
                            true ||
                        // widget.userData["hiringManagerLastName"]?.isNotEmpty ==
                        widget.userData["lastName"]?.isNotEmpty ==
                            true)
                    ? Text(
                        // "${(widget.userData["hiringManagerFirstName"] ?? '').toUpperCase()[0]}${(widget.userData["hiringManagerLastName"] ?? '').toUpperCase()[0]}",
                        "${(widget.userData["firstName"] ?? '').toUpperCase()[0]}${(widget.userData["lastName"] ?? '').toUpperCase()[0]}",
                        style: TextStyle(
                            color: Color(0xFFfd7206),
                            fontSize: widget.sizeInfo.isDesktop ? 16 : 12,
                            fontWeight: FontWeight.w700),
                      )
                    : Icon(
                        Icons.person,
                        size: widget.sizeInfo.isDesktop ? 16 : 14,
                        color: Color(0xFFfd7206),
                      ),
              ),
              Gap(15),
              Text(
                  // "${(widget.userData["hiringManagerFirstName"] ?? '')} ${(widget.userData["hiringManagerLastName"] ?? '')}",
                  "${(widget.userData["firstName"] ?? '')} ${(widget.userData["lastName"] ?? '')}",
                  style: TextStyle(
                      fontSize: widget.sizeInfo.isDesktop ? 16 : 14,
                      fontWeight: FontWeight.bold)),
              Gap(20),
            ],
          ),
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
                        width: MediaQuery.of(context).size.width * 0.2,
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
                            ? MediaQuery.of(context).size.width * 0.60
                            : MediaQuery.of(context).size.width * 0.40,
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
                        width: MediaQuery.of(context).size.width * 0.40,
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
                            ? MediaQuery.of(context).size.width * 0.60
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

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isCurrentUser) ...[
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey,
            child: (widget.userData["firstName"]?.isNotEmpty == true ||
                    widget.userData["lastName"]?.isNotEmpty == true)
                ? Text(
                    "${(widget.userData["firstName"] ?? '').toUpperCase()[0]}${(widget.userData["lastName"] ?? '').toUpperCase()[0]}",
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
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: ChatBubble(
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
            _chatProvider.sendMessage(
                widget.receiverID, _messageController.text);
            _messageController.clear();
            scrollDown();
          },
        )),
        IconButton(
            onPressed: () {
              _chatProvider.sendMessage(
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
