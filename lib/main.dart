import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/preference_view.dart';
import 'package:huzzl_web/views/job%20seekers/register/01%20jobseeker_profile.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/login/login_screen.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branches.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/register/06%20congrats.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HuzzlWeb());
}

class HuzzlWeb extends StatelessWidget {
  const HuzzlWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Galano'),
      // home: AuthWrapper(),
      // home: CongratulationPage(),
      home: PreferenceViewPage(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

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
                  return JobSeekerHomeScreen();
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
