import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/preference_view.dart';
import 'package:huzzl_web/views/job%20seekers/register/01%20jobseeker_profile.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/login/login_screen.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branches.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/register/06%20congrats.dart';
import 'package:huzzl_web/views/recruiters/register/phone_number_verification.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const HuzzlWeb());
  runApp(ChangeNotifierProvider(
    create: (context) => JobProvider(),
    child: HuzzlWeb(),
  ));
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
      home: AuthWrapper(),
      // home: PhoneNumberVerification(
      //   phoneNumber: "+63 9463823503",
      // ),
      // home: JobseekerMainScreen(),
      // home: PreferenceViewPage(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // print(snapshot.data!.id);
                // print('User Document ID (uid): ${snapshot.data!.id}');
                print('Fetching user document...');
                return Center(
                  child: CircularProgressIndicator(),
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
                } else {
                  return LoginRegister();
                }
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
