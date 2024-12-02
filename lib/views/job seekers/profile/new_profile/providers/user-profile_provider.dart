import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/models/user-profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  // Method to fetch and set the user profile based on userId
Future<void> fetchUserProfile(String userId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      _userProfile = UserProfile.fromFirestore(data);
      notifyListeners();
    } else {
      print("User not found");
    }
  } catch (e) {
    print("Error fetching user profile: $e");
  }
}

  // Update the user profile with new data
  void updateUserProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }
}
