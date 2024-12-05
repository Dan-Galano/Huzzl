// ChatHomePage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/chat/services/chat_provider.dart';
import 'package:huzzl_web/views/chat/services/chat_service.dart';
import 'package:huzzl_web/views/chat/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'chat_page.dart';
import 'package:searchable_listview/searchable_listview.dart';

class ChatHomePage extends StatefulWidget {
  final Candidate? candidate; // Nullable candidate

  ChatHomePage({super.key, this.candidate});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with TickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _selectedUserData;
  final TextEditingController _searchController = TextEditingController();

  String? _searchQuery; // Nullable to handle no search case
  bool _isSearching = false;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  void _onSearchClicked() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  void initState() {
    super.initState();

    // If candidate is passed, immediately select the chat
    if (widget.candidate != null) {
      // Split the name into first name and last name
      String fullName = widget.candidate!.name.trim();
      List<String> nameParts = fullName.split(' ');

      // Last name is the last word in the list, first name is everything before that
      String firstName = nameParts.take(nameParts.length - 1).join(' ').trim();
      String lastName = nameParts.isNotEmpty ? nameParts.last.trim() : '';

      // Store the selected user data
      _selectedUserData = {
        "email": widget.candidate?.email,
        "uid": widget.candidate?.id,
        "firstName": firstName, // First name extracted from the full name
        "lastName": lastName, // Last name extracted from the full name
        "hiringManagerFirstName":
            firstName, // First name extracted from the full name
        "hiringManagerLastName":
            lastName, // Last name extracted from the full name
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.width * 0.01),
          child: Column(
            children: [
              // Header Row with "Back" Button and Title
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text(
                          "Back",
                          style: TextStyle(
                            color: Color(0xFFff9800),
                            fontFamily: 'Galano',
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFFff9800),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xff373030),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),

              // Main content layout
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User list on the left
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildSearchBar(),
                          Expanded(child: _buildUserList(sizeInfo)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        color: Colors.grey,
                        width: 0.5,
                        height: double.infinity,
                      ),
                    ),

                    // Chat section on the right
                    Expanded(
                      flex: 3,
                      child: _selectedUserData != null
                          ? ChatPage(
                              userData: _selectedUserData!,
                              receiverEmail: _selectedUserData!["email"] ?? '',
                              receiverID: _selectedUserData!["uid"] ?? '',
                              sizeInfo: sizeInfo,
                            )
                          : const Center(
                              child:
                                  Text("Select a user to start conversation."),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  _searchController, // Bind the controller to the TextField
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.isNotEmpty ? value : null;
                  _isSearching = value.isNotEmpty; // Adjust the search state
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery != null && _searchQuery!.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = null; // Clear the search query
                            _isSearching = false; // Reset search state
                            _searchController
                                .clear(); // Clear the TextField value
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null, // Show no suffix if search query is empty
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _onSearchClicked,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(SizingInformation sizeInfo) {
    final stream = _isSearching
        ? _chatService.getUserStream(searchQuery: _searchQuery)
        : _chatService.getUserStream();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("StreamBuilder Error: ${snapshot.error}");
          return const Text("Error loading users. Please try again later.");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                ),
              );
            },
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No users found.");
        }

        final usersData = snapshot.data!;
        return _buildUserListView(usersData, sizeInfo);
      },
    );
  }

  Widget _buildUserListView(
      List<Map<String, dynamic>> usersData, SizingInformation sizeInfo) {
    final currentUserEmail = getCurrentUser()?.email;

    return ListView.builder(
      itemCount: usersData.length,
      itemBuilder: (context, index) {
        final userData = usersData[index];
        final userDataEmail = userData["email"] as String? ?? '';
        final userId = userData["uid"] as String? ?? '';

        if (userDataEmail.isNotEmpty && userDataEmail != currentUserEmail) {
          bool isSelected = _selectedUserData == userData;

          List<String> ids = [getCurrentUser()!.uid, userId];
          ids.sort();
          String chatRoomID = ids.join('_');

          return FutureBuilder<Map<String, dynamic>>(
            future: _getLastMessageAndTime(chatRoomID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserTile(
                  userData: userData,
                  text: userDataEmail,
                  isSelected: isSelected,
                  sizeInfo: sizeInfo,
                  last_msg: '',
                  last_time: DateTime.now(),
                  onTap: () {
                    setState(() {
                      _selectedUserData = userData;
                    });
                  },
                );
              }

              if (snapshot.hasError) {
                return UserTile(
                  userData: userData,
                  text: userDataEmail,
                  isSelected: isSelected,
                  sizeInfo: sizeInfo,
                  last_msg: 'Error fetching last message',
                  last_time: DateTime.now(),
                  onTap: () {
                    setState(() {
                      _selectedUserData = userData;
                    });
                  },
                );
              }

              final lastMessageData = snapshot.data ?? {};
              final lastMsg = lastMessageData['last_msg'] ?? '';
              final lastTime =
                  (lastMessageData['last_time'] as Timestamp?)?.toDate() ??
                      DateTime.now();

              return UserTile(
                userData: userData,
                text: userDataEmail,
                isSelected: isSelected,
                sizeInfo: sizeInfo,
                last_msg: lastMsg,
                last_time: lastTime,
                onTap: () {
                  setState(() {
                    _selectedUserData = userData;
                  });
                },
              );
            },
          );
        }

        return Container();
      },
    );
  }

  Future<Map<String, dynamic>> _getLastMessageAndTime(String chatRoomID) async {
    try {
      final chatRoomDoc = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (chatRoomDoc.docs.isEmpty) {
        return {'last_msg': '', 'last_time': null};
      }

      final lastMessageDoc = chatRoomDoc.docs.first;
      final messageData = lastMessageDoc.data();
      final lastMsg = messageData['message'] ?? '';
      final lastTime = messageData['timestamp'];

      return {'last_msg': lastMsg, 'last_time': lastTime};
    } catch (e) {
      return {'last_msg': 'Error fetching message', 'last_time': null};
    }
  }
}


  // Widget _buildUserList(SizingInformation sizeInfo) {
  //   if (_cachedUsersData != null) {
  //     return _buildUserListView(_cachedUsersData!, sizeInfo);
  //   }

  //   return StreamBuilder<List<Map<String, dynamic>>>(
  //     stream: _chatService.getUserStream(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         print("Error in user stream: ${snapshot.error}");
  //         return const Text("Error loading users.");
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return ListView.builder(
  //           itemCount: 10,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Shimmer.fromColors(
  //               baseColor: Colors.grey[200]!,
  //               highlightColor: Colors.grey[100]!,
  //               child: Container(
  //                 margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
  //                 padding: EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[200],
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 height: 50,
  //               ),
  //             );
  //           },
  //         );
  //       }

  //       if (!snapshot.hasData || snapshot.data == null) {
  //         return const Text("No users available.");
  //       }

  //       _cachedUsersData = snapshot.data!;

  //       return _buildUserListView(_cachedUsersData!, sizeInfo);
  //     },
  //   );
  // }
