import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';

class HiringManagerProvider extends ChangeNotifier {
  List<HiringManager> _hiringManagers = []; // Store all hiring managers

  // Getter to access the hiring managers
  List<HiringManager> get hiringManagers => _hiringManagers;

  // Fetch all hiring managers once from Firestore
  Future<void> fetchAllHiringManagers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'hiringManager')
          .get();
// Print the number of documents found
      print("Number of hiring managers found: ${querySnapshot.docs.length}");

// Loop through the documents and print each one
      for (var doc in querySnapshot.docs) {
        print("Document ID: ${doc.id}");
        print("Document Data: ${doc.data()}");
      }
      // Clear the existing list and add the fetched data
      _hiringManagers.clear();
      _hiringManagers.addAll(querySnapshot.docs.map((doc) {
        return HiringManager(
          uid: doc.id,
          fname: doc['firstName'] ?? '',
          lname: doc['lastName'] ?? '',
          email: doc['email'] ?? '',
          password: doc.data().containsKey('password')
              ? doc['password']
              : 'defaultPassword',
          phoneNum: doc['phone'] ?? '',
          branchId: doc['branchId'] ?? '',
          created_at: doc['created_at'],
          created_by: doc['created_by'],
        );
      }).toList());

      // Print all hiring managers to the debug console
      for (var manager in _hiringManagers) {
        print(
            "Hiring Manager: ${manager.fname} ${manager.lname} - Email: ${manager.email} - Branch ID: ${manager.branchId}");
      }

      notifyListeners(); // Notify listeners when data is loaded
    } catch (e) {
      print("Error fetching hiring managers: $e");
    }
  }
}
