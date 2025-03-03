import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/screens/main/main_screen.dart';
import 'package:huzzl_web/views/chat/services/chat_provider.dart';
import 'package:huzzl_web/views/job%20seekers/apply/application_prov.dart';
import 'package:huzzl_web/views/job%20seekers/apply/review_details.dart';
import 'package:huzzl_web/views/job%20seekers/controller/jobseeker_provider.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:huzzl_web/views/job%20seekers/home/provider/jobdetails_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/autobuild_resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/Landing_Page/landing_page.dart';
import 'package:huzzl_web/landing%20page/landing_page.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/providers/portfolio_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/providers/user-profile_provider.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/hiringmanager-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/staff-provider.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:huzzl_web/views/recruiters/register/mainHiringManager_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const HuzzlWeb());
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompanyProfileProvider()),
        ChangeNotifierProvider(create: (context) => JobProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BranchProvider()),
        ChangeNotifierProvider(create: (context) => InterviewProvider(context)),
        ChangeNotifierProvider(create: (_) => HiringManagerDetails()),
        ChangeNotifierProvider(create: (context) => ResumeProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AutoBuildResumeProvider()),
        ChangeNotifierProvider(create: (context) => PortfolioProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => JobDetailsProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final hiringManagerProvider = HiringManagerProvider();
            // Return the provider; no need to set hiring managers manually
            return hiringManagerProvider;
          },
        ),

        // StaffProvider with artificial data
        ChangeNotifierProvider(
          create: (context) {
            final staffProvider = StaffProvider();
            // Return the provider; no need to set staff members manually
            return staffProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return JobProviderCandidate();
          },
        ),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        ChangeNotifierProvider(create: (_) => JobseekerProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              return ApplicationProvider(uid: currentUser.uid);
            }
            return ApplicationProvider(
                uid: ""); // Handle the case where no user is logged in
          },
          // child: ReviewDetailsScreen(
          //     uid: FirebaseAuth.instance.currentUser?.uid ?? ""),
        ),
      ],
      // child: MainScreen(),
      child: HuzzlWeb(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = const Color(0xFfd74a4a)
    ..textColor = Colors.white
    ..fontSize = 16.0
    ..indicatorColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = true;
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    configLoading();

    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Galano', scaffoldBackgroundColor: Colors.white),
      home: const AuthWrapper(),
      // home: MyJobsView(),
      // home: MainScreen(),
      // home: JobseekerMainScreen(),
      // home: PreferenceViewPage(),
      // home: const LandingPageNew(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? currentUser; // Track the currently logged-in user

  @override
  void initState() {
    super.initState();
    // Load initial jobs
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs();
    }

    // Manually check if the user is logged in
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
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
                          'assets/images/gif/huzzl_loading.gif',
                          height: 100,
                          width: 100,
                        ),
                        Gap(10),
                        Text(
                          "Just a sec...",
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
            ),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          final loggedInUserId = user.uid;

          final userProvider = Provider.of<UserProvider>(context);
          userProvider.setLoggedInUserId(loggedInUserId);

// Fetch the role from Firestore based on the logged-in user's UID
          FirebaseFirestore.instance
              .collection('users')
              .doc(loggedInUserId)
              .get()
              .then((userDoc) {
            if (userDoc.exists) {
              final data = userDoc.data();
              final role = data?['role'] ??
                  'admin'; // Default to 'admin' if role is not found

              if (role == 'recruiter') {
                final compProvider =
                    Provider.of<CompanyProfileProvider>(context, listen: false);
                compProvider.fetchCompanyDetails(user.uid);
                // compProvider.fetchAllReviews(user.uid);
              }

              if (role == 'jobseeker') {
                // Perform the code block for non-admin users
                final resumeProvider =
                    Provider.of<ResumeProvider>(context, listen: false);

                resumeProvider.updateEmail(user.email!);

                String firstName = data!['firstName'] ?? '';
                String lastName = data!['lastName'] ?? '';
                String pNumber = data!['phoneNumber'] ?? '';

                resumeProvider.updateName(firstName, lastName);
                resumeProvider.updatePhoneNumber(pNumber);
              } else {
                print("Admin user detected. Skipping operation.");
              }
            } else {
              print("User document does not exist.");
            }
          }).catchError((error) {
            print('Error fetching user role from Firestore: $error');
          });

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(loggedInUserId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // print(snapshot.data!.id);
                // print('User Document ID (uid): ${snapshot.data!.id}');
                print('Fetching user document in main.dart...');
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
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
                                'assets/images/gif/huzzl_loading.gif',
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
                  ),
                );
              }
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return ErrorWidget(snapshot.error.toString());
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                print('Data: ${snapshot.data}');
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String userType = userData['role'];
                String uid = snapshot.data!.id;

                if (userType == 'jobseeker') {
                  return JobseekerMainScreen(uid: uid);
                } else if (userType == 'recruiter') {
                  if (userData['subscriptionType'] == 'premium') {
                    print("DATE SUBBED: ${userData['dateSubscribed']
                        .toDate()
                        .add(const Duration(days: 30)).isBefore(DateTime.now())}");
                    if (userData['dateSubscribed']
                        .toDate()
                        .add(const Duration(days: 30))
                        .isBefore(DateTime.now())) {
                      try {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({
                          'subscriptionType': 'basic',
                        });
                        print(
                            'Subscription due date has passed. Subscription type updated to basic');
                      } catch (e) {
                        print('Error updating subscription type: $e');
                      }
                    }
                  }
                  return RecruiterHomeScreen();
                } else if (userType == 'admin') {
                  return MainScreen();
                } else if (userType == 'hiringManager') {
                  return RecruiterHomeScreen();
                } else {
                  return LoginRegister();
                }

                // return ChatHomePage(); //chattest
              }

              return LandingPageNew();
            },
          );
        } else {
          print("LOGIN!");
          return LoginRegister();
        }
      },
    );
  }
}

// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     final jobProvider = Provider.of<JobProvider>(context, listen: false);
//     if (jobProvider.jobs.isEmpty) {
//       jobProvider.loadJobs();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasData) {
//           return FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(snapshot.data!.uid)
//                 .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // print(snapshot.data!.id);
//                 // print('User Document ID (uid): ${snapshot.data!.id}');
//                 print('Fetching user document...');
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               print('TEST');
//               if (snapshot.hasError) {
//                 print('Error: ${snapshot.error}');
//                 return ErrorWidget(snapshot.error.toString());
//               }
//               if (snapshot.hasData && snapshot.data!.exists) {
//                 print('Data: ${snapshot.data}');
//                 var userData = snapshot.data!.data() as Map<String, dynamic>;
//                 String userType = userData['role'];

//                 if (userType == 'jobseeker') {
//                   return JobseekerMainScreen();
//                 } else if (userType == 'recruiter') {
//                   return RecruiterHomeScreen();
//                 } else {
//                   return LoginRegister();
//                 }
//               }
//               return LoginRegister();
//             },
//            );
//         } else {
//           print("LOGIN!");
//           return LoginRegister();
//         }
//       },
//     );
//   }
// }

