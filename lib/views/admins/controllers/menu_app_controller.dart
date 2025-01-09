import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/models/company_information.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/admins/models/subscriber.dart';
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

  List<Subscriber> _allSubscriptions = [];
  List<Subscriber> get allSubscriptions => _allSubscriptions;
  Future<void> fetchAllSubscriptions() async {
    try {
      var subscribersSnapshot = await FirebaseFirestore.instance
          .collection('subscribers')
          .orderBy('dateSubscribed')
          .get();

      _allSubscriptions = subscribersSnapshot.docs.map(
        (doc) {
          return Subscriber(
            uid: doc['uid'],
            hiringManagerFirstName: doc['fname'],
            hiringManagerLastName: doc['lname'],
            phone: doc['phone'],
            dateSubscribed: doc['dateSubscribed'],
            jobPostsCount: doc['jobPostsCount'],
          );
        },
      ).toList();
      print("Successfully fetched all subscription");
      print("NUMBER OF SUBS: ${_subscribers.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching all subscription: $e");
    }
  }

  List<Subscriber> _subscribers = [];
  List<Subscriber> get subscribers => _subscribers;

  Future<void> fetchSubscribers() async {
    try {
      var subscribersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('subscriptionType', isEqualTo: 'premium')
          .where('role', isEqualTo: 'recruiter')
          .orderBy('dateSubscribed')
          .get();

      _subscribers = subscribersSnapshot.docs.map(
        (doc) {
          return Subscriber(
            uid: doc['uid'],
            hiringManagerFirstName: doc['hiringManagerFirstName'],
            hiringManagerLastName: doc['hiringManagerLastName'],
            phone: doc['phone'],
            dateSubscribed: doc['dateSubscribed'],
            jobPostsCount: doc['jobPostsCount'],
          );
        },
      ).toList();
      print("Successfully fetched users (subscribers) !!!");
      print("NUMBER OF SUBS: ${_subscribers.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching users (subscribers): $e");
    }
  }

  List<Subscriber> _basicSubscribers = [];
  List<Subscriber> get basicSubscribers => _basicSubscribers;

  Future<void> fetchBasicSubscribers() async {
    try {
      var subscribersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('subscriptionType', isEqualTo: 'basic')
          .where('role', isEqualTo: 'recruiter')
          .orderBy('dateSubscribed')
          .get();

      _basicSubscribers = subscribersSnapshot.docs.map(
        (doc) {
          return Subscriber(
            uid: doc['uid'],
            hiringManagerFirstName: doc['hiringManagerFirstName'],
            hiringManagerLastName: doc['hiringManagerLastName'],
            phone: doc['phone'],
            dateSubscribed: doc['dateSubscribed'] ?? 'N/A',
            jobPostsCount: doc['jobPostsCount'],
          );
        },
      ).toList();
      print("Successfully fetched basic users (subscribers) !!!");
      print("NUMBER OF SUBS: ${_subscribers.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching basic users (subscribers): $e");
    }
  }

  Future<Map<int, int>> fetchSubscribersByMonth() async {
    try {
      var subscribersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('subscriptionType', isEqualTo: 'premium')
          .get();

      Map<int, int> subscribersByMonth = {};

      for (var doc in subscribersSnapshot.docs) {
        Timestamp timestamp = doc['dateSubscribed'];
        DateTime dateSubscribed = timestamp.toDate();
        int month = dateSubscribed.month;

        // Increment the count for the month
        if (subscribersByMonth.containsKey(month)) {
          subscribersByMonth[month] = subscribersByMonth[month]! + 1;
        } else {
          subscribersByMonth[month] = 1;
        }
      }

      return subscribersByMonth;
    } catch (e) {
      print("Error fetching users (subscribers): $e");
      return {};
    }
  }

  final List<CompanyInformation> _companyInformation = [];
  List<CompanyInformation> get companyInformation => _companyInformation;

  //get pending companies
  List<CompanyInformation> get pendingCompanies {
    return _companyInformation
        .where((company) => company.companyStatus == 'pending')
        .toList();
  }

  //get approved companies
  List<CompanyInformation> get approvedCompanies {
    return _companyInformation
        .where((company) => company.companyStatus == 'approved')
        .toList();
  }

  //get denied companies
  List<CompanyInformation> get deniedCompanies {
    return _companyInformation
        .where((company) => company.companyStatus == 'denied')
        .toList();
  }

  //Business Documents
  Future<void> fetchCompanyInformation() async {
    _companyInformation.clear();
    var usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;

      // Fetch company information sub-collection
      final companyInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('company_information')
          // .where('companyStatus', isEqualTo: 'pending')
          .get();

      for (var companyDoc in companyInfoSnapshot.docs) {
        final data = companyDoc.data();
        print("Fetching in company_information");
        // Map Firestore document to CompanyInformation model
        _companyInformation.add(CompanyInformation(
          uid: data['uid'],
          companyId: companyDoc.id,
          companyName: data['companyName'] ?? 'N/A',
          ceoFirstName: data['ceoFirstName'] ?? 'N/A',
          ceoLastName: data['ceoLastName'] ?? 'N/A',
          industry: data['industry'] ?? 'N/A',
          companyDescription: data['companyDescription'] ?? 'N/A',
          locationOtherInformation: data['locationOtherInformation'] ?? 'N/A',
          city: data['city'] ?? 'N/A',
          region: data['region'] ?? 'N/A',
          province: data['province'] ?? 'N/A',
          createdAt: data['created_at'],
          businessDocuments: List<String>.from(data['businessDocuments'] ?? []),
          companyStatus: data['companyStatus'] ?? 'N/A',
        ));
      }
      notifyListeners();
    }
  }

  Future<void> updateCompanyStatus(
      String uid, String companyId, String newStatus) async {
    try {
      // Reference to the Firestore collection
      CollectionReference companies =
          FirebaseFirestore.instance.collection('users');

      // Update the companyStatus field
      await companies
          .doc(uid)
          .collection("company_information")
          .doc(companyId)
          .update({
        'companyStatus': newStatus, // Set the new status
      });
      notifyListeners();
      await fetchCompanyInformation();
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
  int _totalRecruiters = 0;
  int get totalRecruiters => _totalRecruiters;

  Future<void> recruitersCount({DateTime? startDate, DateTime? endDate}) async {
    print('Counting recruiters');
    if (startDate != null && endDate != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'recruiter')
            .where('created_at',
                isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
            .count()
            .get();
        _totalRecruiters = snapshot.count!;
        notifyListeners();
      } catch (e) {
        print('Error counting documents: $e');
      }
    } else {
      try {
        final snapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'recruiter')
            .count()
            .get();
        _totalRecruiters = snapshot.count!;
        notifyListeners();
      } catch (e) {
        print('Error counting documents: $e');
      }
    }
  }

  //count job seekers
  int _totalJobseekers = 0;
  int get totalJobseekers => _totalJobseekers;

  Future<void> jobseekersCount() async {
    print('Counting jobseekers');

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'jobseeker')
          .count()
          .get();
      _totalJobseekers = snapshot.count!;
      notifyListeners();
    } catch (e) {
      print('Error counting documents: $e');
    }
  }

  //job Posts
  int _totalJobPosts = 0;
  int get totalJobPosts => _totalJobPosts;

  Future<void> jobPostCount() async {
    print('Counting job posts');

    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot usersSnapshot = await usersCollection.get();
      _totalJobPosts = 0;
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        CollectionReference jobPostsCollection =
            usersCollection.doc(userDoc.id).collection('job_posts');

        QuerySnapshot jobPostsSnapshot = await jobPostsCollection.get();
        _totalJobPosts += jobPostsSnapshot.docs.length;
        notifyListeners();
      }
    } catch (e) {
      print("Error counting job posts: $e");
    }
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
          .orderBy('created_at', descending: true)
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
          subscriptionType:
              doc['role'] == 'recruiter' ? doc['subscriptionType'] : 'N/A',
          dateSubscribed: doc['role'] == 'recruiter'
              ? doc['dateSubscribed']
              : Timestamp(0, 0),
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
          subscriptionType:
              doc['role'] == 'recruiter' ? doc['subscriptionType'] : 'N/A',
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

  DateTime? dateStartPicked;
  DateTime? dateEndPicked;

  DateTime? get startDate => dateStartPicked;
  DateTime? get endDate => dateEndPicked;

  void pickStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateStartPicked = picked;
      notifyListeners();
    }
  }

  void pickEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateEndPicked = picked;
      notifyListeners();
    }
  }
}
