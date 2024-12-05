import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huzzl_web/views/chat/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches user data for chat room participants or filtered by search query
  Stream<List<Map<String, dynamic>>> getUserStream({String? searchQuery}) {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final chatRoomsCollection =
        FirebaseFirestore.instance.collection('chat_rooms');
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Search all users matching the query (email, first name, last name, or hiring manager details).
      return usersCollection.snapshots().map((snapshot) {
        try {
          List<Map<String, dynamic>> allUsers = snapshot.docs.map((doc) {
            return {
              ...doc.data(),
              'uid': doc.id,
            } as Map<String, dynamic>;
          }).toList();

          final lowerCaseQuery = searchQuery.toLowerCase();

          // Safely filter out null or empty fields before performing the search.
          return allUsers.where((user) {
            final email = user['email']?.toLowerCase() ?? '';
            final firstName = user['firstName']?.toLowerCase() ?? '';
            final lastName = user['lastName']?.toLowerCase() ?? '';
            final hiringManagerFirstName =
                user['hiringManagerFirstName']?.toLowerCase() ?? '';
            final hiringManagerLastName =
                user['hiringManagerLastName']?.toLowerCase() ?? '';

            return email.contains(lowerCaseQuery) ||
                firstName.contains(lowerCaseQuery) ||
                lastName.contains(lowerCaseQuery) ||
                hiringManagerFirstName.contains(lowerCaseQuery) ||
                hiringManagerLastName.contains(lowerCaseQuery);
          }).toList();
        } catch (e) {
          print("Error in search query: $e");
          return [];
        }
      });
    } else {
      // Load only users with whom the current user has conversations.
      return chatRoomsCollection
          .where('participants', arrayContains: currentUserID)
          .orderBy('last_time',
              descending: true) // Sort by last message time (latest first)
          .snapshots()
          .asyncMap((snapshot) async {
        try {
          List<String> participantIDs = [];
          for (var doc in snapshot.docs) {
            final participants = List<String>.from(doc.data()['participants']);
            participantIDs
                .addAll(participants.where((id) => id != currentUserID));
          }

          // Remove duplicates.
          participantIDs = participantIDs.toSet().toList();

          // Fetch user details for these participant IDs.
          List<Map<String, dynamic>> users = [];
          for (var id in participantIDs) {
            final userDoc = await usersCollection.doc(id).get();
            if (userDoc.exists) {
              users.add({
                ...userDoc.data()!,
                'uid': userDoc.id,
              });
            }
          }
          return users;
        } catch (e) {
          print("Error in fetching participants: $e");
          return [];
        }
      });
    }
  }

  /// Fetches a single user document by email
  Future<Map<String, dynamic>?> fetchUserByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null; // User not found
    }

    return querySnapshot.docs.first.data();
  }

  /// Starts a conversation with a user given their email
  Future<void> startConversation(String email) async {
    final userData = await fetchUserByEmail(email);
    if (userData == null) {
      throw Exception("User with email $email not found.");
    }

    final currentUserID = _auth.currentUser?.uid ?? '';
    final otherUserId = userData['uid'];

    if (currentUserID.isEmpty || otherUserId == null) {
      throw Exception("Invalid current user or recipient.");
    }

    String chatRoomID = _getChatRoomId(otherUserId);

    // Create the chat room if it doesn't exist
    final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomID);
    final chatRoomDoc = await chatRoomRef.get();

    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        'participants': [currentUserID, otherUserId],
        'last_msg': '',
        'last_time': null,
      });
    }
  }

  /// Generates a chat room ID based on participant IDs
  String _getChatRoomId(String otherUserId) {
    final currentUserId = _auth.currentUser!.uid;
    final ids = [currentUserId, otherUserId]..sort();
    return ids.join('_');
  }

  /// Fetches messages for a chat room
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  /// Sends a message to a user
  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message object.
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Create a unique chat room ID using sorted participant IDs.
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add the message to the messages subcollection.
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    // Update the chat room with the latest message, timestamp, and participants.
    await _firestore.collection("chat_rooms").doc(chatRoomID).set(
      {
        'last_msg': message,
        'last_time': timestamp,
        'participants': ids, // Add the participants array to the chat room.
      },
      SetOptions(merge: true),
    );
  }
}














// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FirebaseAuth _auth = FirebaseAuth.instance;



//  Stream<List<Map<String, dynamic>>> getUserStream() {
//   final currentUserID = _auth.currentUser?.uid;

//   return _firestore
//       .collection('chat_rooms')
//       .where('participants', arrayContains: currentUserID)
//       .snapshots()
//       .asyncMap((chatRoomsSnapshot) async {
//     List<Map<String, dynamic>> userList = [];

//     for (var chatRoomDoc in chatRoomsSnapshot.docs) {
//       final chatRoomData = chatRoomDoc.data();
//       final chatRoomId = chatRoomDoc.id;
 
//       final List<dynamic> participants = chatRoomData['participants'];
//       final otherUserId =
//           participants.firstWhere((id) => id != currentUserID, orElse: () => null);

//       if (otherUserId == null) continue;

//       final userDoc = await _firestore.collection('users').doc(otherUserId).get();
//       if (!userDoc.exists) continue; 

//       final userData = userDoc.data() as Map<String, dynamic>;

//       userData['last_msg'] = chatRoomData['last_msg'] ?? '';
//       userData['last_time'] = chatRoomData['last_time'] ?? null;

//       userList.add(userData);
//     }

//     return userList;
//   });
// }

//   String _getChatRoomId(String otherUserId) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     final ids = [currentUserId, otherUserId]..sort();
//     return ids.join('_');
//   }

//   Future<void> sendMessage(String receiverID, message) async {
//     final String currentUserID = _auth.currentUser!.uid;
//     final String currentUserEmail = _auth.currentUser!.email!;
//     final Timestamp timestamp = Timestamp.now();

//     Message newMessage = Message(
//         senderID: currentUserID,
//         senderEmail: currentUserEmail,
//         receiverID: receiverID,
//         message: message,
//         timestamp: timestamp);

//     List<String> ids = [currentUserID, receiverID];
//     ids.sort();
//     String chatRoomID = ids.join('_');
//     await _firestore
//         .collection("chat_rooms")
//         .doc(chatRoomID)
//         .collection("messages")
//         .add(newMessage.toMap());

//     await _firestore.collection("chat_rooms").doc(chatRoomID).set(
//         {'last_msg': message, 'last_time': timestamp}, SetOptions(merge: true));
//   }

//   Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
//     List<String> ids = [userID, otherUserID];
//     ids.sort();
//     String chatRoomID = ids.join('_');
//     return _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomID)
//         .collection('messages')
//         .orderBy("timestamp", descending: false)
//         .snapshots();
//   }

  
// }









