// ChatHomePage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/chat/services/chat_provider.dart';
import 'package:huzzl_web/views/chat/services/chat_service.dart';
import 'package:huzzl_web/views/chat/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'chat_page.dart';
import 'package:searchable_listview/searchable_listview.dart';

class ChatHomePage extends StatefulWidget {
  ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with TickerProviderStateMixin {
  late final ChatProvider _chatProvider;
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _selectedUserData;

  List<Map<String, dynamic>>? _cachedUsersData;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User logged out successfully.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginRegister()));
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _chatProvider.loadChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    // TabController _tabController = TabController(length: 2, vsync: this);
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Messages"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 0, right: 20, bottom: 20),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildUserList(sizeInfo),
                ),
                Flexible(
                  flex: 3,
                  child: _selectedUserData != null
                      ? ChatPage(
                          userData: _selectedUserData!,
                          receiverEmail: _selectedUserData!["email"],
                          receiverID: _selectedUserData!["uid"],
                          sizeInfo: sizeInfo,
                        )
                      : Center(
                          child: Text("Select a user to start conversation.")),
                ),
              ],
            ),
          ),
        );
      });
    });
  }


  Widget _buildUserList(SizingInformation sizeInfo) {
    if (_cachedUsersData != null) {
      return _buildUserListView(_cachedUsersData!, sizeInfo);
    }
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error in user stream: ${snapshot.error}");
          return const Text("Error loading users.");
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

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No users available.");
        }

        _cachedUsersData = List<Map<String, dynamic>>.from(snapshot.data!);

        return _buildUserListView(_cachedUsersData!, sizeInfo);
      },
    );
  }


  Widget _buildUserListView(
      List<Map<String, dynamic>> usersData, SizingInformation sizeInfo) {
    final currentUserEmail = getCurrentUser()?.email;

    List<Map<String, dynamic>> _filterUsers(
        String query, List<Map<String, dynamic>> users) {
      return users.where((userData) {
        final email = userData["email"];
        final firstName = userData["hiringManagerFirstName"] ?? '';
        final lastName = userData["hiringManagerLastName"] ?? '';
        final fullName = '$firstName $lastName'.toLowerCase();
        return email != null &&
            email != currentUserEmail &&
            (email.toLowerCase().contains(query.toLowerCase()) ||
                firstName.toLowerCase().contains(query.toLowerCase()) ||
                lastName.toLowerCase().contains(query.toLowerCase()) ||
                fullName.contains(query.toLowerCase()));
      }).toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SearchableList<Map<String, dynamic>>(
        cursorColor: Color(0xFFfe9703),
        listViewPadding: EdgeInsets.all(0),
        initialList: usersData,
        filter: (query) => _filterUsers(query, usersData),
        errorWidget: Icon(Icons.error),
        itemBuilder: (userData) => _buildUserListItem(userData, sizeInfo),
        emptyWidget: Center(child: Text('Not found')),
        style: TextStyle(fontSize: 16),
        inputDecoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFfe9703), width: 1),
          ),
          hintText: 'Search...',
          hintStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(Icons.search),
        ),
        displaySearchIcon: false,
        displayClearIcon: true,
        scrollDirection: Axis.vertical,
        spaceBetweenSearchAndList: 20,
      ),
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, SizingInformation sizeInfo) {
    final currentUserEmail = getCurrentUser()?.email;
    final userDataEmail = userData["email"];
    final userId = userData["uid"];

    if (userDataEmail != null && userDataEmail != currentUserEmail) {
      bool isSelected = _selectedUserData == userData;

      List ids = [getCurrentUser()!.uid, userId];
      ids.sort();
      String chatRoomID = ids.join('_');
      final lastMsgData = _chatProvider.chatRoomsData[chatRoomID];

      final lastMsg = lastMsgData?['last_msg'] ?? '';
      final lastTime =
          (lastMsgData?['last_time'] as Timestamp?)?.toDate() ?? DateTime.now();

      return UserTile(
        userData: userData,
        text: userDataEmail,
        isSelected: isSelected,
        sizeInfo: sizeInfo,
        last_msg: lastMsg,
        last_time: lastTime,
        unreadCount: 5,
        onTap: () {
          setState(() {
            _selectedUserData = userData;
          });
        },
      );
    } else {
      return Container();
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



  // Widget _buildUserListView(
  //     List<Map<String, dynamic>> usersData, SizingInformation sizeInfo) {
  //   final currentUserEmail = getCurrentUser()?.email;

  //   List<Map<String, dynamic>> _filterUsers(
  //       String query, List<Map<String, dynamic>> users) {
  //     return users.where((userData) {
  //       final email = userData["email"];
  //       final firstName = userData["firstName"];
  //       final lastName = userData["lastName"];
  //       final fullName = '$firstName $lastName'.toLowerCase();
  //       return email != null &&
  //           email != currentUserEmail &&
  //           (email.toLowerCase().contains(query.toLowerCase()) ||
  //               firstName.toLowerCase().contains(query.toLowerCase()) ||
  //               lastName.toLowerCase().contains(query.toLowerCase()) ||
  //               fullName.contains(query.toLowerCase()));
  //     }).toList();
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: SearchableList<Map<String, dynamic>>(
  //       cursorColor: Color(0xFFfe9703),
  //       listViewPadding: EdgeInsets.all(0),
  //       initialList: usersData,
  //       filter: (query) => _filterUsers(query, usersData),
  //       errorWidget: Icon(Icons.error),
  //       itemBuilder: (userData) => _buildUserListItem(userData, sizeInfo),
  //       emptyWidget: Center(child: Text('No users found')),
  //       style: TextStyle(fontSize: 16),
  //       inputDecoration: InputDecoration(
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: Color(0xFFfe9703), width: 1),
  //         ),
  //         hintText: 'Search...',
  //         hintStyle: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //         prefixIcon: Icon(Icons.search),
  //       ),
  //       displaySearchIcon: false,
  //       displayClearIcon: true,
  //       scrollDirection: Axis.vertical,
  //       spaceBetweenSearchAndList: 20,
  //     ),
  //   );
  // }
