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
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/Landing_Page/landing_page.dart';
import 'package:huzzl_web/landing%20page/landing_page.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/hiringmanager-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/staff-provider.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
   await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const HuzzlWeb());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JobProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BranchProvider()),
        ChangeNotifierProvider(create: (context) => InterviewProvider()),
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
        ChangeNotifierProvider(create: (context) => MenuAppController()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
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
      theme: ThemeData(fontFamily: 'Galano'),
      // home: const AuthWrapper(),
      // home: MainScreen(),
      // home: JobseekerMainScreen(),
      // home: PreferenceViewPage(),
      home: const LandingPageNew(),
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
    // final jobProvider = Provider.of<JobProvider>(context, listen: false);
    // if (jobProvider.jobs.isEmpty) {
    //   jobProvider.loadJobs();
    // }

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
          final loggedInUserId = snapshot.data!.uid; // Get the user ID
          Provider.of<UserProvider>(context, listen: false)
              .setLoggedInUserId(loggedInUserId); // Update UserProvider

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(loggedInUserId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // print(snapshot.data!.id);
                // print('User Document ID (uid): ${snapshot.data!.id}');
                print('Fetching user document...');
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
              print('TEST');
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return ErrorWidget(snapshot.error.toString());
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                print('Data: ${snapshot.data}');
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String userType = userData['role'];

                if (userType == 'jobseeker') {
                  return JobseekerMainScreen();
                } else if (userType == 'recruiter') {
                  return RecruiterHomeScreen();
                } else if (userType == 'admin'){
                  return MainScreen();
                }
                 else {
                  return LoginRegister();
                }

                // return ChatHomePage(); //chattest
              }

              return LoginRegister();
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
//           );
//         } else {
//           print("LOGIN!");
//           return LoginRegister();
//         }
//       },
//     );
//   }
// }

