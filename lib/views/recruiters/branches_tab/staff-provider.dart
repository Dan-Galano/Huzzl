// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';

// // Define the StaffProvider

// class StaffProvider extends ChangeNotifier {
//   List<Staff> _staffMembers = [];

//   List<Staff> get staffMembers => _staffMembers;

//   void setStaffMembers(List<Staff> staff) {
//     _staffMembers = staff;
//     notifyListeners();
//   }

//   // Method to add a new staff member
//   Future<void> addStaff({
//     required String fname,
//     required String lname,
//     required String email,
//     String? phoneNum,
//     required String branchId,
//   }) async {
//     try {
//       // Create a new Staff instance
//       final newStaff = Staff(
//         fname: fname,
//         lname: lname,
//         email: email,
//         phoneNum: phoneNum,
//         branchId: branchId,
//       );

//       // Add the staff member to Firestore
//       final docRef = await FirebaseFirestore.instance.collection('staff').add({
//         'fname': newStaff.fname,
//         'lname': newStaff.lname,
//         'email': newStaff.email,
//         'phoneNum': newStaff.phoneNum,
//         'branchId': newStaff.branchId,
//       });

//       // Add the new staff to the local list with the Firestore ID
//       _staffMembers.add(Staff(
//         fname: newStaff.fname,
//         lname: newStaff.lname,
//         email: newStaff.email,
//         phoneNum: newStaff.phoneNum,
//         branchId: branchId,
//       ));

//       notifyListeners(); // Notify listeners that the list has changed

//       // Debug output after storing
//       print("Staff added: ${docRef.id}");
//     } catch (e) {
//       // Handle errors appropriately
//       print("Error adding staff: $e");
//       throw e; // Optionally throw the error to the UI
//     }
//   }

//   // Method to fetch staff members associated with a specific branch
//   Future<void> fetchStaffByBranch(String branchId) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('staff')
//           .where('branchId', isEqualTo: branchId)
//           .get();

//       // Map the fetched documents to Staff instances
//       _staffMembers = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Staff(
//           fname: data['fname'],
//           lname: data['lname'],
//           email: data['email'],
//           phoneNum: data['phoneNum'],
//           branchId: data['branchId'],
//         );
//       }).toList();

//       notifyListeners(); // Notify listeners that the staff list has changed
//     } catch (e) {
//       print("Error fetching staff: $e");
//       throw e; // Optionally throw the error to the UI
//     }
//   }

//   // Method to get a specific staff member
//   Staff getStaff(int index) {
//     if (index < 0 || index >= _staffMembers.length) {
//       throw IndexError(index, _staffMembers);
//     }
//     return _staffMembers[index];
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';

class StaffProvider extends ChangeNotifier {
  List<Staff> _staffMembers = [];
  bool _isLoading = false; // Loading state

  List<Staff> get staffMembers => _staffMembers;
  bool get isLoading => _isLoading; 
  void setStaffMembers(List<Staff> staff) {
    _staffMembers = staff;
    notifyListeners();
  }

  // Temporary method to set staff members manually (for testing)

  // Method to add a new staff member
  Future<void> addStaff({
    required String fname,
    required String lname,
    required String email,
    required String password,
    String? phoneNum,
    required String branchId,
  }) async {
    try {
      // Create a new Staff instance
      final newStaff = Staff(
        fname: fname,
        lname: lname,
        email: email,
        password: password,
        phoneNum: phoneNum,
        branchId: branchId,
      );

      // Add the staff member to Firestore
      final docRef = await FirebaseFirestore.instance.collection('staff').add({
        'fname': newStaff.fname,
        'lname': newStaff.lname,
        'email': newStaff.email,
        'phoneNum': newStaff.phoneNum,
        'branchId': newStaff.branchId,
      });

      // Add the new staff to the local list with the Firestore ID
      _staffMembers.add(newStaff); // Correctly add the new staff member

      notifyListeners(); // Notify listeners that the list has changed

      // Debug output after storing
      print("Staff added: ${docRef.id}");
    } catch (e) {
      // Handle errors appropriately
      print("Error adding staff: $e");
      throw e; // Optionally throw the error to the UI
    }
  }

  // Method to fetch staff members associated with a specific branch
  Future<void> fetchStaffByBranch(String loggedInUserId, String branchId) async {
     _isLoading = true; 
    notifyListeners();
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('branches')
          .doc(branchId)
          .collection('staffs')
          .orderBy('created_at', descending: true)
          .get();

      List<Staff> staffList = snapshot.docs.map((doc) {
        // Assuming the Staff class has a fromMap method to convert Firestore data to Staff object
        return Staff.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Sorting the local list by created_at in descending order
      staffList.sort((a, b) => b.created_at!.compareTo(a.created_at!));

      setStaffMembers(staffList); // Update local list and notify listeners

      // Debug output after fetching
      print("Fetched ${staffList.length} staff members for branch: $branchId");
    } catch (e) {
      // Handle errors appropriately
      print("Error fetching staff: $e");
      throw e; // Optionally throw the error to the UI
     } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

// Method to get a specific staff member
  Staff getStaff(int index) {
    if (index < 0 || index >= _staffMembers.length) {
      throw IndexError(index, _staffMembers);
    }
    return _staffMembers[index];
  }
}
