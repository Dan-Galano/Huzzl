import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Staff {
  final String fname;
  final String lname;
  final String email;
  final String password;
  final String? phoneNum;
  final String branchId;
  final Timestamp? created_at;
  final String? created_by;

  Staff({
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    this.phoneNum,
    required this.branchId,
    this.created_at,
    this.created_by,
  });

  // Factory method to create a Staff instance from a map
  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      fname: data['firstName'] ?? '', // Provide a default value if null
      lname: data['lastName'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phoneNum: data['phone'], // Nullable
      branchId: data['branchId'] ?? '',
      created_at: data['created_at'] as Timestamp?, // Cast to Timestamp
      created_by: data['created_by'], // Nullable
    );
  }

  // Optionally, you can also add a toMap method to convert a Staff instance to a map
  Map<String, dynamic> toMap() {
    return {
      'firstName': fname,
      'lastName': lname,
      'email': email,
      'password': password,
      'phone': phoneNum,
      'branchId': branchId,
      'created_at': created_at,
      'created_by': created_by,
    };
  }
}


class HiringManager {
  final String fname;
  final String lname;
  final String email;
  String password;
  final String? phoneNum;
  final String branchId;
  Timestamp? created_at;
  String? created_by;

  HiringManager({
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    this.phoneNum,
    required this.branchId,
    this.created_at,
    this.created_by,
  });
}

class Branch {
  String id;
  String branchName;
  String firstName;
  String lastName;
  String phone;
  String email;
  String password;
  String region;
  String province;
  String city;
  String barangay;
  String zip;
  String house;
  String estDate;
  bool isMain;
  Timestamp? created_at;
  String? created_by;
  bool isActive;
  Timestamp? last_updated_at;
  Timestamp? last_archived_at;
  Timestamp? last_reactivated_at;

  Branch({
    required this.id,
    required this.branchName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.region,
    required this.province,
    required this.city,
    required this.barangay,
    required this.zip,
    required this.house,
    required this.estDate,
    this.isMain = false,
    this.isActive = true,
    this.created_at,
    this.created_by,
    this.last_updated_at,
    this.last_archived_at,
    this.last_reactivated_at,
  });
}
