import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branches.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/candidates-tab.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/interview-tab.dart';
import 'package:huzzl_web/views/recruiters/home/jobs-tab.dart';
import 'package:huzzl_web/views/recruiters/home/manager-tab.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterHomeScreen extends StatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  Map<String, dynamic>? companyData;
  Map<String, dynamic>? userData;
  bool? isStandaloneCompany;
  void getcompanyData() async {
    // Get the current user after they sign in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // The UID of the signed-in user
      String uid = user.uid;

      // Company Info
      DocumentSnapshot companyDocument = await FirebaseFirestore.instance
          .collection(
              'recruiters_company_info') // Assuming 'companyData' is the collection
          .doc(uid) // Access the document with the user's UID
          .get();
      //USer info
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('users') // Assuming 'companyData' is the collection
          .doc(uid) // Access the document with the user's UID
          .get();

      // Check if the document exists
      if (companyDocument.exists && userDocument.exists) {
        // Get the user's data
        setState(() {
          companyData = companyDocument.data() as Map<String, dynamic>;
          userData = userDocument.data() as Map<String, dynamic>;

          if (companyData!["companySize"] == "It's just me") {
            isStandaloneCompany = true;
          } else {
            isStandaloneCompany = false;
          }
        });

        print("User Data: ${companyData.toString()}");
      } else {
        print("No user data found for UID: $uid");
      }
    } else {
      print("No user signed in.");
    }
  }

  @override
  void initState() {
    super.initState();
    getcompanyData();
  }

  int? _selectedIndex = 4; // Default the first tab na (Managers)

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildContent() {
    if (companyData == null || isStandaloneCompany == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show a loader while fetching data
    }
    if (isStandaloneCompany!) {
      switch (_selectedIndex) {
        case 0:
          return buildManagersContent(
              context, userData, companyData, isStandaloneCompany);
        case 1:
          return buildJobsContent();
        case 2:
          return buildCandidatesContent(context);
        case 3:
          return buildInterviewsContent();
        default:
          return Text("No content available");
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return buildManagersContent(
              context, userData, companyData, isStandaloneCompany);
        case 1:
          return BranchesScreen();
        case 2:
          return buildJobsContent();
        case 3:
          return buildCandidatesContent(context);
        case 4:
          return buildInterviewsContent();
        default:
          return Text("No content available");
      }
    }
  }

  //logout
  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User logged out successfully.");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NavBarLoginRegister(),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon:
                Image.asset('assets/images/chat-icon-recruiter.png', width: 25),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/notif-icon-recruiter.png',
                width: 25),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: Image.asset('assets/images/building-icon-recruiter.png',
                width: 25),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: companyData == null || isStandaloneCompany == null
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                isStandaloneCompany!
                    ? NavigationRail(
                        backgroundColor: const Color(0xFF23294F),
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: changeDestination,
                        minWidth: 200,
                        labelType: NavigationRailLabelType.none,
                        leading: const SizedBox(height: 20),
                        useIndicator: true,
                        indicatorColor: Colors.orange,
                        destinations: <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/manager-tab.png', 'Managers', 0),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/jobs-tab.png', 'Jobs', 1),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/candidates-tab.png',
                                'Candidates',
                                2),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/interview-tab.png',
                                'Interviews',
                                3),
                            label: const SizedBox.shrink(),
                          ),
                        ],
                      )
                    : NavigationRail(
                        backgroundColor: const Color(0xFF23294F),
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: changeDestination,
                        minWidth: 200,
                        labelType: NavigationRailLabelType.none,
                        leading: const SizedBox(height: 20),
                        useIndicator: true,
                        indicatorColor: Colors.orange,
                        destinations: <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/manager-tab.png', 'Managers', 0),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/branches-tab.png',
                                'Branches',
                                1),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/jobs-tab.png', 'Jobs', 2),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/candidates-tab.png',
                                'Candidates',
                                3),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/interview-tab.png',
                                'Interviews',
                                4),
                            label: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                const VerticalDivider(thickness: 1, width: 1),
                // Expanded makes sure the content takes up the remaining space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Text("Header for all"),
                        Expanded(
                          child: buildContent(), // contents goes here
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Galano",
            ),
          ),
        ],
      ),
    );
  }
}
