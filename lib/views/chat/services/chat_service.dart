import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huzzl_web/views/chat/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;



 Stream<List<Map<String, dynamic>>> getUserStream() {
  final currentUserID = _auth.currentUser?.uid;

  return _firestore
      .collection('chat_rooms')
      .where('participants', arrayContains: currentUserID)
      .snapshots()
      .asyncMap((chatRoomsSnapshot) async {
    List<Map<String, dynamic>> userList = [];

    for (var chatRoomDoc in chatRoomsSnapshot.docs) {
      final chatRoomData = chatRoomDoc.data();
      final chatRoomId = chatRoomDoc.id;

      // Get the other participant's ID (i.e., the recruiter)
      final List<dynamic> participants = chatRoomData['participants'];
      final otherUserId =
          participants.firstWhere((id) => id != currentUserID, orElse: () => null);

      if (otherUserId == null) continue; // Skip if no valid other participant is found

      // Fetch the other participant's user data from the users collection
      final userDoc = await _firestore.collection('users').doc(otherUserId).get();
      if (!userDoc.exists) continue; // Skip if the user doesn't exist

      final userData = userDoc.data() as Map<String, dynamic>;

      // Add last message and timestamp from the chat room document
      userData['last_msg'] = chatRoomData['last_msg'] ?? '';
      userData['last_time'] = chatRoomData['last_time'] ?? null;

      userList.add(userData);
    }

    return userList;
  });
}

  String _getChatRoomId(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final ids = [currentUserId, otherUserId]..sort();
    return ids.join('_');
  }

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    await _firestore.collection("chat_rooms").doc(chatRoomID).set(
        {'last_msg': message, 'last_time': timestamp}, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
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
}



// Stream<List<Map<String, dynamic>>> getUserStream() {
//   return _firestore
//       .collection('users')
//       .where('role', whereIn: ['jobseeker', 'recruiter']) // Filter by role
//       .snapshots()
//       .map((snapshot) {
//         return snapshot.docs
//             .map((doc) {
//               final data = doc.data() as Map<String, dynamic>;

//               // Ensure non-null fields
//               return {
//                 'uid': doc.id,
//                 'firstName': data['firstName'] ?? 'Huzzl',
//                 'lastName': data['lastName'] ?? 'User',
//                 'email': data['email'] ?? 'huzzluser@gmail.com',
//                 'role': data['role'],
//               };
//             })
//             .toList();
//       });
// }