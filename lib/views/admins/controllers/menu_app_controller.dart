import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/login/login_register.dart';

class MenuAppController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  //HERE -> new code

  int _sideMenuIndex = 0;
  int get sideMenuIndex => _sideMenuIndex;

  void changeTabLocation(int index) {
    _sideMenuIndex = index;
    notifyListeners();
  }

  //Count recruiters
  Future<int> recruitersCount() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'recruiter')
          .count()
          .get();
      return snapshot.count!;
    } catch (e) {
      print('Error counting documents: $e');
      return 0;
    }
  }

  //count job seekers
  Future<int> jobseekersCount() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'jobseeker')
          .count()
          .get();
      return snapshot.count!;
    } catch (e) {
      print('Error counting documents: $e');
      return 0;
    }
  }

  //job Posts

  Future<int> jobPostCount() async {
    int totalJobPosts = 0;

    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot usersSnapshot = await usersCollection.get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        CollectionReference jobPostsCollection =
            usersCollection.doc(userDoc.id).collection('job_posts');

        QuerySnapshot jobPostsSnapshot = await jobPostsCollection.get();

        totalJobPosts += jobPostsSnapshot.docs.length;
      }
    } catch (e) {
      print("Error counting job posts: $e");
      return 0;
    }

    return totalJobPosts;
  }

  //fetch recently created account
  Future<List<RecentUser>> fetchRecentUsers() async {
    List<RecentUser> recentUsers = [];

    try {
      // Reference to the 'users' collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query to get the 10 most recent users based on the 'timestamp'
      QuerySnapshot querySnapshot = await usersCollection
          .where('role', whereIn: ['jobseeker', 'recruiter'])
          .limit(10)
          .get();

      // Check the number of documents fetched
      print("Number of users fetched: ${querySnapshot.docs.length}");

      // Map the results to a list of User objects
      recentUsers = querySnapshot.docs.map((doc) {
        return RecentUser(
          uid: doc['uid'],
          email: doc['email'],
          icon: doc['role'] == 'recruiter'
              ? 'assets/images/company-black.png'
              : 'assets/images/job-seeker-black.png', // Or fetch dynamically if required
          fname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerFirstName']}"
              : "${doc['firstName']}",
          lname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerLastName']}"
              : "${doc['lastName']}",
          role: doc['role'] == 'recruiter'
              ? 'Recruiter'
              : 'Jobseeker', // Set the correct role here
        );
      }).toList();
    } catch (e) {
      print("Error fetching recent users: $e");
    }

    return recentUsers;
  }

  // admin name
  String _adminName = "";
  String get adminName => _adminName;
  void getName() async {
    final uid = getCurrentUser();

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      _adminName = "${userDoc['first_name']} ${userDoc['last_name']}";
    } else {
      _adminName = 'Unknown';
    }
    notifyListeners();
  }

  String getCurrentUser() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  void logout(BuildContext context) async {
    try {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginRegister(),
        ),
      );
      await FirebaseAuth.instance.signOut();

      print("User logged out successfully.");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  //Business docs
  Future<List<String>> listFiles(String directoryPath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref(directoryPath);
      final listResult = await storageRef.listAll();
      final urls = await Future.wait(
        listResult.items.map((item) => item.getDownloadURL()),
      );
      return urls;
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }
}


