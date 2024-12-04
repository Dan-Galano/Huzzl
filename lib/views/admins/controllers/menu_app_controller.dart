import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/models/company_information.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';

class MenuAppController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  List<CompanyInformation> _companyInformation = [];
  List<CompanyInformation> get companyInformation => _companyInformation;

  //Business Documents
  void fetchBusinessDocuments(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("company_information")
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        _companyInformation.add(
          CompanyInformation(
              uid: data['uid'],
              companyName: data['companyName'],
              ceoFirstName: data['ceoFirstName'],
              ceoLastName: data['ceoLastName'],
              industry: data['industry'],
              companyDescription: data['companyDescription'],
              locationOtherInformation: data['locationOtherInformation'],
              city: data['city'],
              region: data['region'],
              province: data['province'],
              createdAt: data['created_at'],
              businessDocuments: data['businessDocuments'],
              companyStatus: data['companyStatus'],
              ),
        );
      }
    } catch (e) {
      print('Error fetching company information (business documents): $e');
    }
  }

  Future<void> updateCompanyStatus(String companyId, String newStatus) async {
  try {
    // Reference to the Firestore collection
    CollectionReference companies =
        FirebaseFirestore.instance.collection('users');

    // Update the companyStatus field
    await companies.doc(companyId)
          .collection("company_information")
          .doc()
          .update({
      'companyStatus': newStatus, // Set the new status
    });

    print("Company status updated to: $newStatus");
  } catch (e) {
    print("Error updating company status: $e");
    // Handle the error (e.g., show a snackbar or alert)
  }
}

  int _sideMenuIndex = 0;
  int get sideMenuIndex => _sideMenuIndex;

  void changeTabLocation(int index) {
    _sideMenuIndex = index;
    notifyListeners();
  }

  // Show a loading dialog
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Loading, please wait...',
        );
      },
    );
  }

  final List<String> _industries = [
    'Aerospace & Defense',
    'Agriculture',
    'Arts, Entertainment & Recreation',
    'Automotive',
    'Education',
    'Energy, Mining & Utilities',
    'Fashion & Beauty',
    'Finance & Accounting',
    'Food & Beverage',
    'Government & Public Administration',
    'Healthcare',
    'Hotels & Travel Accommodation',
    'Human Resources & Staffing',
    'Information Technology',
    'Insurance',
    'Legal',
    'Management & Consulting',
    'Manufacturing',
    'Media & Entertainment',
    'Military & Defense',
    'Mining',
    'Real Estate',
    'Retail & Consumer Goods',
    'Sales & Marketing',
    'Science & Medicine',
    'Sports & Medicine',
    'Supply Chain',
    'Transportation & Warehousing',
    'Travel & Hospitality',
  ];
  List<String> get industries => _industries;

  //Add an Industy
  void addIndustry(String industry) {
    _industries.add(industry);
    _industries.sort((a, b) => a.compareTo(b)); // Sort alphabetically
    notifyListeners();
  }

  // Edit an industry
  void editIndustry(String oldIndustry, String newIndustry) {
    final index = _industries.indexOf(oldIndustry);
    if (index != -1) {
      _industries[index] =
          newIndustry; // Update the industry at the found index
      _industries.sort((a, b) => a.compareTo(b)); // Sort alphabetically
      notifyListeners();
    }
  }

  // Delete an industry
  void deleteIndustry(String industry) {
    _industries.remove(industry);
    _industries.sort((a, b) => a.compareTo(b)); // Sort alphabetically
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

  List<RecentUser> _recentUsers = [];
  List<RecentUser> get recentUsers => _recentUsers;

  List<RecentUser> _recruiters = [];
  List<RecentUser> get recruiters => _recruiters;

  List<RecentUser> _jobseekers = [];
  List<RecentUser> get jobseekers => _jobseekers;

  //fetch recently created account
  Future<void> fetchRecentUsers() async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await usersCollection
          .where('role', whereIn: ['jobseeker', 'recruiter'])
          .limit(10)
          .get();

      _recentUsers = querySnapshot.docs.map((doc) {
        return RecentUser(
          uid: doc['uid'],
          email: doc['email'],
          icon: doc['role'] == 'recruiter'
              ? 'assets/images/company-black.png'
              : 'assets/images/job-seeker-black.png',
          fname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerFirstName']}"
              : "${doc['firstName']}",
          lname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerLastName']}"
              : "${doc['lastName']}",
          role: doc['role'] == 'recruiter' ? 'Recruiter' : 'Jobseeker',
          status: doc['accStatus'],
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching recent users: $e");
    }
  }

  //fetch recruiters
  Future<void> fetchRecruitersOnly() async {
    try {
      print('--------------- FETCHING RECRUITERS -----------------');
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot =
          await usersCollection.where('role', whereIn: ['recruiter']).get();

      _recruiters = querySnapshot.docs.map((doc) {
        return RecentUser(
          uid: doc['uid'],
          email: doc['email'],
          icon: doc['role'] == 'recruiter'
              ? 'assets/images/company-black.png'
              : 'assets/images/job-seeker-black.png',
          fname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerFirstName']}"
              : "${doc['firstName']}",
          lname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerLastName']}"
              : "${doc['lastName']}",
          role: doc['role'] == 'recruiter' ? 'Recruiter' : 'Jobseeker',
          status: doc['accStatus'],
        );
      }).toList();
      print('--------------- FETCHED ALL RECRUITERS -----------------');
      notifyListeners();
    } catch (e) {
      print("Error fetching recent users: $e");
    }
  }

  //fetch jobseekers
  Future<void> fetchJobseekersOnly() async {
    try {
      print('--------------- FETCHING JOBSEEKERS -----------------');
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot =
          await usersCollection.where('role', whereIn: ['jobseeker']).get();

      _jobseekers = querySnapshot.docs.map((doc) {
        return RecentUser(
          uid: doc['uid'],
          email: doc['email'],
          icon: doc['role'] == 'recruiter'
              ? 'assets/images/company-black.png'
              : 'assets/images/job-seeker-black.png',
          fname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerFirstName']}"
              : "${doc['firstName']}",
          lname: doc['role'] == 'recruiter'
              ? "${doc['hiringManagerLastName']}"
              : "${doc['lastName']}",
          role: doc['role'] == 'recruiter' ? 'Recruiter' : 'Jobseeker',
          status: doc['accStatus'],
        );
      }).toList();
      print('--------------- FETCHED ALL JOBSEEKERS -----------------');
      notifyListeners();
    } catch (e) {
      print("Error fetching recent users: $e");
    }
  }

  Future<void> disableUserAcc(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'accStatus': 'disabled'},
        SetOptions(merge: true),
      );
      debugPrint('User with UID $uid has been successfully disabled.');
    } catch (e) {
      debugPrint('Failed to disable user with UID $uid: $e');
    }
    notifyListeners();
    fetchRecentUsers();
  }

  Future<void> enableUserAcc(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'accStatus': 'enabled'},
        SetOptions(merge: true),
      );
      debugPrint('User with UID $uid has been successfully enabled.');
    } catch (e) {
      debugPrint('Failed to enable user with UID $uid: $e');
    }
    notifyListeners();
    fetchRecentUsers();
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
