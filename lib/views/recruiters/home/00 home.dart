import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/admin/admin_tab.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/branches.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/managers-tab.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/candidates-tab.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_screen.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_sl_screen.dart';
import 'package:huzzl_web/views/recruiters/home/PopupMenuItem/logout.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/calendar.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/interview-tab.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/job-posts-screens/00%20job-screen.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  int? _selectedIndex = 1;
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
      return Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          content: Container(
            width: 105,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  Gap(10),
                  Image.asset(
                    'assets/images/huzzl_loading.gif',
                    height: 100,
                    width: 100,
                  ),
                  Gap(10),
                  Text(
                    "Welcome back...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFfd7206),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return buildAdminContent(context, userData);
      case 1:
        return BuildManagersTabContent();
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
    String convertToRelativeTime(String dateString) {
      // Parse the string into DateTime
      DateFormat format =
          DateFormat('MMMM d, yyyy h:mm a'); // Date format of input string
      DateTime dateTime =
          format.parse(dateString); // Convert the string to DateTime

      // Use timeago to calculate the relative time
      return timeago.format(dateTime,
          locale: 'en_short'); // e.g., "30m ago", "2h ago", "1d ago"
    }

    String dateString = "October 11, 2024 3:00 PM";
    print(convertToRelativeTime(dateString));

    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Scaffold(
        
        backgroundColor: Colors.white, //hahahah dito ka nagstart bhiee
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor:
              sizingInformation.isDesktop ? Colors.white : Color(0xFF23294F),
          title: Row(
            children: [
              !sizingInformation.isDesktop
                  ? SvgPicture.asset(
                      'assets/images/huzzl_ulo.svg',
                      height: 35,
                    )
                  : Image.asset('assets/images/huzzl.png', width: 100)
            ],
          ),
          automaticallyImplyLeading: false,
          leading: !sizingInformation.isDesktop
              ? Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Open the drawer
                    },
                  ),
                )
              : null,
          actions: [
            sizingInformation.isDesktop
                ? IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/chat-icon-recruiter.png',
                        width: 25),
                  )
                : IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
            const SizedBox(width: 10),
            sizingInformation.isDesktop
                ? IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/notif-icon-recruiter.png',
                        width: 25),
                  )
                : IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
            const SizedBox(width: 10),
            sizingInformation.isDesktop
                ? IconButton(
                    onPressed: () {
                      showRecruiterLogoutDialog(context);
                    },
                    icon: Image.asset(
                        'assets/images/building-icon-recruiter.png',
                        width: 25),
                  )
                : IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.business,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        body: Row(
          children: [
            if (sizingInformation.isDesktop)
              NavigationRail(
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
                        'assets/images/branches-tab.png', 'Branches', 2),
                    label: const SizedBox.shrink(),
                  ),
                  NavigationRailDestination(
                    icon:
                        _buildNavItem('assets/images/jobs-tab.png', 'Jobs', 3),
                    label: const SizedBox.shrink(),
                  ),
                  NavigationRailDestination(
                    icon: _buildNavItem(
                        'assets/images/candidates-tab.png', 'Candidates', 4),
                    label: const SizedBox.shrink(),
                  ),
                  NavigationRailDestination(
                    icon: _buildNavItem(
                        'assets/images/interview-tab.png', 'Interviews', 5),
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

        drawer: sizingInformation.isMobile || sizingInformation.isTablet
            ? Container(
                width: 250,
                child: Drawer(
                  child: Container(
                    color: const Color(0xFF23294F),
                    child: Column(
                      children: [
                        // Add the huzzl.png at the top
                        Gap(20),
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Adjust padding as needed
                          child: Image.asset('assets/images/huzzl.png',
                              width: 100), // Adjust width or path if necessary
                        ),
                        const SizedBox(
                            height:
                                10), // Add a gap before the navigation items

                        // NavigationRail inside the Drawer
                        Expanded(
                          child: NavigationRail(
                            backgroundColor: const Color(0xFF23294F),
                            selectedIndex: _selectedIndex,
                            onDestinationSelected: (int index) {
                              // Change the destination and close the drawer
                              changeDestination(index);
                              Navigator.of(context).pop();
                            },
                            minWidth: 200,
                            labelType: NavigationRailLabelType.none,
                            leading: const SizedBox(
                                height: 20), // Adjust space if necessary
                            useIndicator: true,
                            indicatorColor: Colors.orange,
                            destinations: <NavigationRailDestination>[
                              NavigationRailDestination(
                                icon: _buildNavItem(
                                    'assets/images/manager-tab.png',
                                    'Admin',
                                    0),
                                label: const SizedBox.shrink(),
                              ),
                              NavigationRailDestination(
                                icon: _buildNavItem(
                                    'assets/images/manager-tab.png',
                                    'Managers',
                                    1),
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
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      );
    });
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
