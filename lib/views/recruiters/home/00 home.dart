import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/admin/admin_tab.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branches.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/candidates-tab.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_screen.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_sl_screen.dart';
import 'package:huzzl_web/views/recruiters/home/PopupMenuItem/companyProfile.dart';
import 'package:huzzl_web/views/recruiters/home/PopupMenuItem/logout.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/calendar.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/interview-tab.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/00%20job-screen.dart';
import 'package:huzzl_web/views/recruiters/managers_tab/manager-tab.dart';
import 'package:huzzl_web/widgets/navbar/navbar_home.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterHomeScreen extends StatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  State<RecruiterHomeScreen> createState() => RecruiterHomeScreenState();
}

class RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  Map<String, dynamic>? companyData;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> jobPostsData = [];
  User? user;
  bool? isStandaloneCompany;

  void getcompanyData() async {
    // Get the current user after they sign in
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });

    if (user != null) {
      // The UID of the signed-in user
      String uid = user!.uid;

      // Fetch company info from the subcollection
      QuerySnapshot companySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('company_information')
          .get();

      QuerySnapshot jobPostsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('job_posts')
          .get();

      // Fetch user info
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('users') // Access the 'users' collection
          .doc(uid) // Access the document with the user's UID
          .get();

      // Check if the user document exists and the company subcollection has data
      if (companySnapshot.docs.isNotEmpty && userDocument.exists) {
        setState(() {
          // Extract the first document from the company_information subcollection (or handle multiple documents as needed)
          companyData =
              companySnapshot.docs.first.data() as Map<String, dynamic>;
          userData = userDocument.data() as Map<String, dynamic>;
          jobPostsData = jobPostsSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          print(jobPostsData);
          print(companyData!["companySize"]);
          // Check company size field to set the isStandaloneCompany flag
          if (companyData!["companySize"] == "It's just me") {
            isStandaloneCompany = true;
          } else {
            isStandaloneCompany = false;
          }

          // Update the user and company data
          this.companyData = companyData;
          this.userData = userData;
        });

        print("Company Data: ${companyData.toString()}");
        print("User Data: ${userData.toString()}");
      } else {
        print("No company or user data found for UID: $uid");
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

  int? _selectedIndex = 3;
  bool _isApplicationScreen = false;
  bool _isSlApplicationScreen = false;
  bool _isCalendarScreen = false;

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleApplicationScreen(bool showApplicationScreen) {
    setState(() {
      _isApplicationScreen = showApplicationScreen;
    });
  }

  void toggleSlApplicationScreen(bool showApplicationScreen) {
    setState(() {
      _isSlApplicationScreen = showApplicationScreen;
    });
  }

  void toggleCalendarScreen(bool showCalendarScreen) {
    setState(() {
      _isCalendarScreen = showCalendarScreen;
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
          return JobScreens(
            jobPostsData: jobPostsData,
            user: user!,
          );
        case 2:
          if (_isApplicationScreen) {
            return ApplicationScreen(
              onBack: () => toggleApplicationScreen(false),
            );
          } else if (_isSlApplicationScreen) {
            return SlApplicationScreen(
              onBack: () => toggleSlApplicationScreen(false),
            );
          }
          return buildCandidatesContent(context);
        case 3:
          if (_isCalendarScreen) {
            return InterviewCalendar(
              onBack: () => toggleCalendarScreen(false),
            );
          }
          return buildInterviewsContent();
        default:
          return Text("No content available");
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return buildAdminContent(context, userData);
        case 1:
          return buildManagersContent(
              context, userData, companyData, isStandaloneCompany);
        case 2:
          return BranchesScreen();
        case 3:
          return JobScreens(
            jobPostsData: jobPostsData,
            user: user!,
          );
        case 4:
          if (_isApplicationScreen) {
            return ApplicationScreen(
              onBack: () => toggleApplicationScreen(false),
            );
          } else if (_isSlApplicationScreen) {
            return SlApplicationScreen(
              onBack: () => toggleSlApplicationScreen(false),
            );
          }
          return buildCandidatesContent(context);
        case 5:
          if (_isCalendarScreen) {
            return InterviewCalendar(
              onBack: () => toggleCalendarScreen(false),
            );
          }
          return buildInterviewsContent();
        default:
          return Text("No content available");
      }
    }
  }

  //logout
  // void logOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     print("User logged out successfully.");
  //   } catch (e) {
  //     print("Error signing out: $e");
  //   }
  // }

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
            onPressed: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final position =
                  button.localToGlobal(Offset.zero, ancestor: overlay);
              await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  overlay.size.width - position.dx,
                  position.dy + 55,
                  position.dx + 30,
                  overlay.size.height - position.dy,
                ),
                items: [
                  const PopupMenuItem(
                    value: 'company_profile',
                    child: Row(
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          color: Color(0xff373030),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Company Profile',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'close_account',
                    child: Row(
                      children: [
                        Icon(
                          Icons.close_outlined,
                          color: Color(0xff373030),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Close Account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Color(0xff373030),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ).then((value) {
                switch (value) {
                  case 'company_profile':
                    showCompanyProfile(context);
                    break;
                  case 'close_account':
                    showCloseAccountDialog(context);
                    break;
                  case 'logout':
                    showRecruiterLogoutDialog(context);
                    break;
                }
              });
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
                                'assets/images/manager-tab.png', 'Admin', 0),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/manager-tab.png', 'Managers', 1),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/branches-tab.png',
                                'Branches',
                                2),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/jobs-tab.png', 'Jobs', 3),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/candidates-tab.png',
                                'Candidates',
                                4),
                            label: const SizedBox.shrink(),
                          ),
                          NavigationRailDestination(
                            icon: _buildNavItem(
                                'assets/images/interview-tab.png',
                                'Interviews',
                                5),
                            label: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: buildContent(),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
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
      ),
    );
  }
}
