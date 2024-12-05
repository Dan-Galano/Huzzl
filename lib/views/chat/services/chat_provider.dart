// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';



// class ChatProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Map<String, Map<String, dynamic>> _chatRoomsData = {};
//   String? _emailFilter;

//   Map<String, Map<String, dynamic>> get chatRoomsData => _chatRoomsData;

//   void setEmailFilter(String? email) {
//     _emailFilter = email;
//     loadChatRooms(); // Refresh chat rooms based on new filter
//   }

//   Future<void> loadChatRooms() async {
//     final String currentUserID = _auth.currentUser!.uid;

//     Query query = _firestore
//         .collection('chat_rooms')
//         .where('participants', arrayContains: currentUserID);

//     final chatRoomsSnapshot = await query.get();

//     _chatRoomsData.clear();

//     for (var doc in chatRoomsSnapshot.docs) {
//       final data = doc.data();
//       final lastMsg = data['last_msg'] ?? '';
//       final lastTime = data['last_time'] ?? Timestamp.now();
//       final chatRoomID = doc.id;

//       // Filter by email if filter is set
//       if (_emailFilter != null) {
//         final otherUserId = (data['participants'] as List<dynamic>)
//             .firstWhere((id) => id != currentUserID, orElse: () => null);
//         if (otherUserId == null) continue;

//         final userDoc =
//             await _firestore.collection('users').doc(otherUserId).get();
//         if (!userDoc.exists) continue;

//         final userEmail = userDoc.data()?['email'] ?? '';
//         if (userEmail.toLowerCase() != _emailFilter!.toLowerCase()) {
//           continue; // Skip if email doesn't match filter
//         }
//       }

//       _chatRoomsData[chatRoomID] = {
//         'last_msg': lastMsg,
//         'last_time': lastTime,
//       };
//     }

//     notifyListeners();
//   }
// }













// class ChatProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Map<String, Map<String, dynamic>> _chatRoomsData = {};

//   Map<String, Map<String, dynamic>> get chatRoomsData => _chatRoomsData;

//   Future<void> loadChatRooms() async {
//     final String currentUserID = _auth.currentUser!.uid;

//     final chatRoomsSnapshot = await _firestore
//         .collection('chat_rooms')
//         .where('participants',
//             arrayContains: currentUserID) 
//         .get();

//     _chatRoomsData.clear();

//     for (var doc in chatRoomsSnapshot.docs) {
//       final data = doc.data();
//       final lastMsg = data['last_msg'] ?? '';
//       final lastTime = data['last_time'] ?? Timestamp.now();
//       final chatRoomID = doc.id;

//       _chatRoomsData[chatRoomID] = {
//         'last_msg': lastMsg,
//         'last_time': lastTime,
//       };
//     }

//     notifyListeners();
//   }

// }
