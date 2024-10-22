import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';

class BranchProvider extends ChangeNotifier {
  List<Branch> _branches = [];
  int _activeBranchCount = 0;
  int _archiveBranchCount = 0;
  int _searchActiveBranchCount = 0;
  int _searchArchiveBranchCount = 0;
  List<Branch> _searchResults = []; // Store search results here
  String _currentSearchQuery = "";
  bool _isLoading = false; // Loading state
  TabController? _tabController;

  void setTabController(TabController tabController) {
    _tabController = tabController; // Set the TabController
  }

  // New method to change tab index
  void changeTabIndex(int index) {
    if (_tabController != null) {
      _tabController!.index = index; // Change the tab index
      notifyListeners(); // Notify listeners about the change
    }
  }

  int get currentTabIndex {
    return _tabController?.index ?? 0; // Return 0 if _tabController is null
  }

  // Change the tab index to the next tab
  void toggleTabIndex() {
    if (_tabController != null) {
      // Change to the next tab (0 to 1 or 1 to 0)
      final newIndex =
          (_tabController!.index + 1) % 2; // Assuming there are only 2 tabs
      _tabController!.index = newIndex; // Update the index
      notifyListeners(); // Notify listeners about the change
    }
  }

  bool get isLoading => _isLoading;
  List<Branch> get branches => _branches;
  int get activeBranchCount => _activeBranchCount;
  int get archiveBranchCount => _archiveBranchCount;
  int get searchActiveBranchCount => _searchActiveBranchCount;
  int get searchArchiveBranchCount => _searchArchiveBranchCount;

  List<Branch> get searchResults => _searchResults; // Getter for search results
  String get currentSearchQuery => _currentSearchQuery;

  void setBranches(List<Branch> branches) {
    _branches = branches;
    notifyListeners();
  }

  // Method to get a specific branch
  Branch getBranch(int index) {
    return _branches[index];
  }

  Future<void> fetchActiveBranchCount(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('branches')
          .where('isActive', isEqualTo: true) // Filter for active branches
          .get();

      _activeBranchCount =
          querySnapshot.docs.length; // Get the count of active branches
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print("Error fetching active branch count: $e");
    } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

  Future<void> fetchArchiveBranchCount(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('branches')
          .where('isActive', isEqualTo: false) // Filter for active branches
          .get();

      _archiveBranchCount =
          querySnapshot.docs.length; // Get the count of active branches
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print("Error fetching archive branch count: $e");
    } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

  // Method to save a new branch
  Future<void> saveBranch({
    required String userId,
    required String branchName,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String region,
    required String province,
    required String city,
    required String barangay,
    required String zip,
    required String house,
    required String estDate,
    bool isMain = false,
  }) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('branches')
          .add({
        'branchName': branchName.trim(),
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phone': phone.trim(),
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'region': region.trim(),
        'province': province.trim(),
        'city': city.trim(),
        'barangay': barangay.trim(),
        'zip': zip.trim(),
        'house': house.trim(),
        'estDate': estDate.trim(),
        'isMain': isMain,
        'created_at': Timestamp.now(), // Add created_at timestamp
        'created_by': userId, // Optional: if needed
      });

      // Add the new branch to the local list and notify listeners
      _branches.add(Branch(
        id: docRef.id,
        branchName: branchName,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        region: region,
        province: province,
        city: city,
        barangay: barangay,
        zip: zip,
        house: house,
        estDate: estDate,
        isMain: isMain,
      ));

      notifyListeners(); // Notify listeners that the list has changed

      // Debug output after storing
      print("Branch added: ${docRef.id}");
    } catch (e) {
      print("Error adding branch: $e");
    }
  }

  // Method to fetch branches from Firestore
  Future<void> fetchActiveBranches(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('branches')
          .where('isActive', isEqualTo: true)
          .get();

      List<Branch> fetchedBranches = [];
      Branch? mainBranch;

      for (var doc in querySnapshot.docs) {
        // Read estDate as a string
        String estDateString =
            "N/A"; // Default value if 'estDate' does not exist

        // Check if the field exists before accessing it
        if (doc.data().containsKey('estDate')) {
          estDateString = doc['estDate'];
        } else {
          // Log a warning if the field is missing
          print(
              "Warning: 'estDate' field does not exist for document ID: ${doc.id}");
        }

        // Create the branch object
        Branch branch = Branch(
          id: doc.id,
          branchName: doc['branchName'],
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          phone: doc['phone'],
          email: doc['email'],
          password: doc['password'],
          region: doc['region'],
          province: doc['province'],
          city: doc['city'],
          barangay: doc['barangay'],
          zip: doc['zip'],
          house: doc['house'],
          estDate: estDateString,
          isMain: doc['isMain'] ?? false,
          isActive: doc['isActive'] ?? true,
          created_at: doc['created_at'],
          // last_reactivated_at: doc['last_reactivated_at'] ?? Timestamp.now(),
        );

        if (branch.isMain) {
          mainBranch = branch; // Store the main branch separately
        } else {
          fetchedBranches.add(branch); // Add non-main branches to the list
        }
      }

      // Sort the remaining branches by created_at in descending order
      fetchedBranches.sort((a, b) {
        // Ensure created_at is compared correctly
        Timestamp aCreatedAt =
            a.created_at ?? Timestamp.now(); // Fallback to current time
        Timestamp bCreatedAt =
            b.created_at ?? Timestamp.now(); // Fallback to current time
        return bCreatedAt.compareTo(aCreatedAt); // Sort in descending order
      });

      // If a main branch exists, add it to the front of the list
      if (mainBranch != null) {
        fetchedBranches.insert(
            0, mainBranch); // Insert main branch at the start
      }

      setBranches(fetchedBranches); // Update the local list
      await fetchActiveBranchCount(userId);
      await fetchArchiveBranchCount(userId);
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> searchActiveBranch(String query, userId) async {
    _currentSearchQuery = query.trim().toLowerCase(); // Normalize the query
    notifyListeners(); // Notify listeners immediately
    if (_currentSearchQuery.isEmpty) {
      await fetchActiveBranches(userId);
      _searchResults.clear(); // Clear search results
      notifyListeners(); // Notify listeners
      return;
    }

    try {
      // Normalize the search query
      String normalizedQuery = query.trim().toLowerCase();

      // Fetch all branches first
      final querySearchResult = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Replace with actual userId or pass it as a parameter
          .collection('branches')
          .where('isActive', isEqualTo: true)
          .get();

      _searchResults = querySearchResult.docs.map((doc) {
        return Branch(
          id: doc.id,
          branchName: doc['branchName'],
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          phone: doc['phone'],
          email: doc['email'],
          password: doc['password'],
          region: doc['region'],
          province: doc['province'],
          city: doc['city'],
          barangay: doc['barangay'],
          zip: doc['zip'],
          house: doc['house'],
          estDate: doc['estDate'],
          isMain: doc['isMain'] ?? false,
          isActive: doc['isActive'] ?? true,
          created_at: doc['created_at'],
        );
      }).toList();

      // Split the normalized query into separate words
      List<String> queryParts = normalizedQuery.split(' ');

      // Filter the branches based on the search query
      List<Branch> filteredBranches = _searchResults.where((branch) {
        bool matches = true;
        for (var part in queryParts) {
          matches = matches &&
              (branch.firstName.toLowerCase().contains(part) ||
                  branch.lastName.toLowerCase().contains(part));
        }
        return matches ||
            branch.branchName.toLowerCase().contains(normalizedQuery) ||
            branch.phone.toLowerCase().contains(normalizedQuery) ||
            branch.email.toLowerCase().contains(normalizedQuery) ||
            branch.region.toLowerCase().contains(normalizedQuery) ||
            branch.province.toLowerCase().contains(normalizedQuery) ||
            branch.city.toLowerCase().contains(normalizedQuery) ||
            branch.barangay.toLowerCase().contains(normalizedQuery) ||
            branch.zip.toLowerCase().contains(normalizedQuery) ||
            branch.estDate.toLowerCase().contains(normalizedQuery);
      }).toList();

      setBranches(
          filteredBranches); // Update the local list with filtered branches

      _searchActiveBranchCount = filteredBranches.length;
      notifyListeners();
    } catch (e) {
      print("Error searching branches: $e");
    }
  }

  Future<void> fetchArchiveBranches(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('branches')
          .where('isActive', isEqualTo: false)
          .get();

      List<Branch> fetchedBranches = [];
      Branch? mainBranch;

      for (var doc in querySnapshot.docs) {
        // Read estDate as a string
        String estDateString =
            "N/A"; // Default value if 'estDate' does not exist

        // Check if the field exists before accessing it
        if (doc.data().containsKey('estDate')) {
          estDateString = doc['estDate'];
        } else {
          // Log a warning if the field is missing
          print(
              "Warning: 'estDate' field does not exist for document ID: ${doc.id}");
        }

        // Create the branch object
        Branch branch = Branch(
          id: doc.id,
          branchName: doc['branchName'],
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          phone: doc['phone'],
          email: doc['email'],
          password: doc['password'],
          region: doc['region'],
          province: doc['province'],
          city: doc['city'],
          barangay: doc['barangay'],
          zip: doc['zip'],
          house: doc['house'],
          estDate: estDateString,
          isMain: doc['isMain'] ?? false,
          isActive: doc['isActive'] ?? true,
          created_at: doc['created_at'],
          last_archived_at: doc['last_archived_at'],
        );

        if (branch.isMain) {
          mainBranch = branch; // Store the main branch separately
        } else {
          fetchedBranches.add(branch); // Add non-main branches to the list
        }
      }

      // Sort the remaining branches by created_at in descending order
      fetchedBranches.sort((a, b) {
        // Ensure created_at is compared correctly
        Timestamp aCreatedAt =
            a.last_archived_at ?? Timestamp.now(); // Fallback to current time
        Timestamp bCreatedAt =
            b.last_archived_at ?? Timestamp.now(); // Fallback to current time
        return bCreatedAt.compareTo(aCreatedAt); // Sort in descending order
      });
      print(fetchedBranches);

      // If a main branch exists, add it to the front of the list
      if (mainBranch != null) {
        fetchedBranches.insert(
            0, mainBranch); // Insert main branch at the start
      }

      setBranches(fetchedBranches); // Update the local list
      await fetchActiveBranchCount(userId);
      await fetchArchiveBranchCount(userId);
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> searchArchiveBranch(String query, userId) async {
    _currentSearchQuery = query.trim().toLowerCase(); // Normalize the query
    notifyListeners(); // Notify listeners immediately
    if (_currentSearchQuery.isEmpty) {
      await fetchArchiveBranches(userId);
      _searchResults.clear(); // Clear search results
      notifyListeners(); // Notify listeners
      return;
    }

    try {
      // Normalize the search query
      String normalizedQuery = query.trim().toLowerCase();

      // Fetch all branches first
      final querySearchResult = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Replace with actual userId or pass it as a parameter
          .collection('branches')
          .where('isActive', isEqualTo: false)
          .get();

      _searchResults = querySearchResult.docs.map((doc) {
        return Branch(
          id: doc.id,
          branchName: doc['branchName'],
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          phone: doc['phone'],
          email: doc['email'],
          password: doc['password'],
          region: doc['region'],
          province: doc['province'],
          city: doc['city'],
          barangay: doc['barangay'],
          zip: doc['zip'],
          house: doc['house'],
          estDate: doc['estDate'],
          isMain: doc['isMain'] ?? false,
          isActive: doc['isActive'] ?? true,
          created_at: doc['created_at'],
        );
      }).toList();

      // Split the normalized query into separate words
      List<String> queryParts = normalizedQuery.split(' ');

      // Filter the branches based on the search query
      List<Branch> filteredBranches = _searchResults.where((branch) {
        bool matches = true;
        for (var part in queryParts) {
          matches = matches &&
              (branch.firstName.toLowerCase().contains(part) ||
                  branch.lastName.toLowerCase().contains(part));
        }
        return matches ||
            branch.branchName.toLowerCase().contains(normalizedQuery) ||
            branch.phone.toLowerCase().contains(normalizedQuery) ||
            branch.email.toLowerCase().contains(normalizedQuery) ||
            branch.region.toLowerCase().contains(normalizedQuery) ||
            branch.province.toLowerCase().contains(normalizedQuery) ||
            branch.city.toLowerCase().contains(normalizedQuery) ||
            branch.barangay.toLowerCase().contains(normalizedQuery) ||
            branch.zip.toLowerCase().contains(normalizedQuery) ||
            branch.estDate.toLowerCase().contains(normalizedQuery);
      }).toList();

      setBranches(
          filteredBranches); // Update the local list with filtered branches

      _searchArchiveBranchCount = filteredBranches.length;
      notifyListeners();
    } catch (e) {
      print("Error searching branches: $e");
    }
  }
}









//search including staffs (issue: mabagallll )
//  Future<void> searchData(String query, String? userId) async {
//   _currentSearchQuery = query.trim().toLowerCase(); // Normalize the query
//   notifyListeners(); // Notify listeners immediately
//   if (_currentSearchQuery.isEmpty) {
//     await fetchActiveBranches(userId!);
//     _searchResults.clear(); // Clear search results
//     notifyListeners(); // Notify listeners
//     return;
//   }

//   try {
//     // Normalize the search query
//     String normalizedQuery = query.trim().toLowerCase();

//     // Fetch all branches first
//     final querySearchResult = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('branches')
//         .where('isActive', isEqualTo: true)
//         .get();

//     // Fetch staff members for each branch and filter based on search query
//     List<Branch> filteredBranches = [];
//     for (var branchDoc in querySearchResult.docs) {
//       // Create a Branch object
//       Branch branch = Branch(
//         id: branchDoc.id,
//         branchName: branchDoc['branchName'],
//         firstName: branchDoc['firstName'],
//         lastName: branchDoc['lastName'],
//         phone: branchDoc['phone'],
//         email: branchDoc['email'],
//         password: branchDoc['password'],
//         region: branchDoc['region'],
//         province: branchDoc['province'],
//         city: branchDoc['city'],
//         barangay: branchDoc['barangay'],
//         zip: branchDoc['zip'],
//         house: branchDoc['house'],
//         estDate: branchDoc['estDate'],
//         isMain: branchDoc['isMain'] ?? false,
//         isActive: branchDoc['isActive'] ?? true,
//         created_at: branchDoc['created_at'],
//       );

//       // Check if any branch field matches the search query
//       bool matchesBranchFields = branch.branchName.toLowerCase().contains(normalizedQuery) ||
//           branch.firstName.toLowerCase().contains(normalizedQuery) ||
//           branch.lastName.toLowerCase().contains(normalizedQuery) ||
//           branch.phone.toLowerCase().contains(normalizedQuery) ||
//           branch.email.toLowerCase().contains(normalizedQuery) ||
//           branch.region.toLowerCase().contains(normalizedQuery) ||
//           branch.province.toLowerCase().contains(normalizedQuery) ||
//           branch.city.toLowerCase().contains(normalizedQuery) ||
//           branch.barangay.toLowerCase().contains(normalizedQuery) ||
//           branch.zip.toLowerCase().contains(normalizedQuery) ||
//           branch.estDate.toLowerCase().contains(normalizedQuery);

//       // If the branch matches, add it to the filtered list
//       if (matchesBranchFields) {
//         filteredBranches.add(branch);
//         continue; // Skip staff search if branch matches
//       }

//       // Fetch staff for the current branch
//       final staffQuerySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('branches')
//           .doc(branch.id)
//           .collection('staffs')
//           .get();

//       // Check if any staff member matches the search query
//       bool hasMatchingStaff = staffQuerySnapshot.docs.any((staffDoc) {
//         String firstName = staffDoc['firstName'].toString().toLowerCase();
//         String lastName = staffDoc['lastName'].toString().toLowerCase();
//         String phone = staffDoc['phone'].toString().toLowerCase();
//         String email = staffDoc['email'].toString().toLowerCase();

//         return firstName.contains(normalizedQuery) ||
//             lastName.contains(normalizedQuery) ||
//             phone.contains(normalizedQuery) ||
//             email.contains(normalizedQuery);
//       });

//       // If there are matching staff, add the branch to filtered results
//       if (hasMatchingStaff) {
//         filteredBranches.add(branch);
//       }
//     }

//     setBranches(filteredBranches); // Update the local list with filtered branches

//     _searchActiveBranchCount = filteredBranches.length;
//     notifyListeners(); // Notify listeners after completing the search
//   } catch (e) {
//     print("Error searching data: $e");
//   }
// }
