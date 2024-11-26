import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, Map<String, dynamic>> _chatRoomsData = {};

  // Getter to access last messages for all chatrooms
  Map<String, Map<String, dynamic>> get chatRoomsData => _chatRoomsData;

  Future<void> loadChatRooms() async {
    final String currentUserID = _auth.currentUser!.uid;

    final chatRoomsSnapshot = await _firestore
        .collection('chat_rooms')
        .where('participants',
            arrayContains: currentUserID) // filter by current user's chatrooms
        .get();

    _chatRoomsData.clear();

    for (var doc in chatRoomsSnapshot.docs) {
      final data = doc.data();
      final lastMsg = data['last_msg'] ?? '';
      final lastTime = data['last_time'] ?? Timestamp.now();
      final chatRoomID = doc.id;

      _chatRoomsData[chatRoomID] = {
        'last_msg': lastMsg,
        'last_time': lastTime,
      };
    }

    notifyListeners();
  }

  // Method to send a message and update last message info
  Future<void> sendMessageOG(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Message model (optional) can be added to keep the data structure clean
    final newMessage = {
      'senderID': currentUserID,
      'senderEmail': currentUserEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };

    // Sort IDs to create chat room ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add the message to Firestore
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage);

    // Update last message and timestamp in the chat room
    await _firestore.collection("chat_rooms").doc(chatRoomID).set(
      {'last_msg': message, 'last_time': timestamp},
      SetOptions(merge: true),
    );

    notifyListeners();
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // Sort IDs to create chat room ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add the message to Firestore
    final newMessage = {
      'senderID': currentUserID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage);

    // Update the last message and timestamp in Firestore
    await _firestore.collection("chat_rooms").doc(chatRoomID).set(
      {'last_msg': message, 'last_time': timestamp},
      SetOptions(merge: true),
    );

    // Update the last message and timestamp in the provider
    _chatRoomsData[chatRoomID] = {
      'last_msg': message,
      'last_time': timestamp,
    };

    notifyListeners();
  }
}
