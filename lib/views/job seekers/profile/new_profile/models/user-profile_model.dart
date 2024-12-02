import 'package:flutter/material.dart';

class UserProfile {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role;
  List<String>? currentSelectedJobTitles;
  Map<String, dynamic>? selectedLocation; // Map for location data
  Map<String, dynamic>? selectedPayRate; // Map for pay rate data

  // Constructor to initialize the object
  UserProfile({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.currentSelectedJobTitles,
    this.selectedLocation,
    this.selectedPayRate,
  });

  // Factory constructor to create a UserProfile object from Firestore data
  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      role: data['role'],
      currentSelectedJobTitles: List<String>.from(data['currentSelectedJobTitles'] ?? []),
      selectedLocation: data['selectedLocation'] ?? {},
      selectedPayRate: data['selectedPayRate'] ?? {},
    );
  }

  // Convert UserProfile object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'currentSelectedJobTitles': currentSelectedJobTitles,
      'selectedLocation': selectedLocation,
      'selectedPayRate': selectedPayRate,
    };
  }
}
