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
   Future<void> updateUserProfile(String userId) async {
    try {
      // Get the reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Prepare the updated data to save
      Map<String, dynamic> updatedData = _userProfile?.toMap() ?? {};

      // Update the user profile in Firestore
      await userRef.update(updatedData);

      // After update, notify listeners
      print("User profile updated successfully!");
      notifyListeners();
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }
// UserProfileProvider
Future<void> updatePayRate(String userId, String rate, int? min, int? max) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'selectedPayRate': {
        'rate': rate,
        'minimum': min,
        'maximum': max,
      },
    });

    // Update the local userProfile after successful Firestore update
    if (_userProfile != null) {
      _userProfile!.selectedPayRate = {
        'rate': rate,
        'minimum': min,
        'maximum': max,
      };
      notifyListeners();
    }

  } catch (e) {
    print("Error updating pay rate: $e");
  }
}

  // UserProfileProvider
Future<void> updateLocation(
    String userId,
    Map<String, String> location) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'selectedLocation': location,
    });

    // Update the local userProfile after successful Firestore update
    if (_userProfile != null) {
      _userProfile!.selectedLocation = location;
      notifyListeners();
    }
  } catch (e) {
    print("Error updating location: $e");
  }
}
// UserProfileProvider
Future<void> updateJobTitles(String userId, List<String> jobTitles) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'currentSelectedJobTitles': jobTitles,
    });

    // Update the local userProfile after successful Firestore update
    if (_userProfile != null) {
      _userProfile!.currentSelectedJobTitles = jobTitles;
      notifyListeners();
    }
  } catch (e) {
    print("Error updating job titles: $e");
  }
}


}
