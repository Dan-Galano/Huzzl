import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/register/company_profile_v2.dart';
import 'package:huzzl_web/views/recruiters/register/phone_number_verification.dart';
import 'package:huzzl_web/views/recruiters/register/signup_recruiter.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';

class VerifyEmailRecruiter extends StatefulWidget {
  final UserCredential userCredential;
  final String email;
  final String fname;
  final String lname;
  final String password;
  final String phoneNumber;

  VerifyEmailRecruiter({
    required this.userCredential,
    required this.email,
    required this.fname,
    required this.lname,
    required this.password,
    required this.phoneNumber,
    super.key,
  });

  @override
  State<VerifyEmailRecruiter> createState() => _VerifyEmailRecruiterState();
}

class _VerifyEmailRecruiterState extends State<VerifyEmailRecruiter> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? resendTimer;
  bool canResendEmail = false;
  int remainingTime = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
      startResendTimer();
    }
  }

  void startResendTimer() {
    setState(() {
      canResendEmail = false; // Hide resend button initially
      remainingTime = 300; // Reset the timer to 5 minutes
    });

    resendTimer?.cancel(); // Cancel any existing timer
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--; // Decrease the timer every second
        });
      } else {
        setState(() {
          canResendEmail = true; // Show resend button after 5 minutes
        });
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    resendTimer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      resendTimer?.cancel();
      showVerificationDialog();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userCredential.user!.uid)
          .set({
        'uid': widget.userCredential.user!.uid,
        'role': "recruiter",
        'hiringManagerFirstName': widget.fname,
        'hiringManagerLastName': widget.lname,
        'phone': widget.phoneNumber,
        'email': widget.email,
        'password': widget.password,
      }); 
 EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
      EasyLoading.showToast(
        "✓ Your email has been verified!",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => PhoneNumberVerification(
                  phoneNumber: widget.phoneNumber,
                  userCredential: widget.userCredential,
                )),
      );
    }
  }

  void showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
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
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/gif/huzzl_loading.gif',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Verifying...",
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
        );
      },
    );
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      startResendTimer();
       EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "Verification link has been sent to your email!",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
    } catch (e) {
       EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color(0xFfd74a4a)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "Failed to send verification link: $e",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
    }
  }

  String formatRemainingTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBarLoginRegister(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 850,
                      height: 450,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/validation_logo.png',
                              height: 85,
                            ),
                            const SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'A verification link has been sent to',
                                    style: const TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${widget.email}',
                                    style: const TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 25,
                                      color: Color(0xffFD7206),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Click the link sent to your email address to verify your account.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Galano',
                              ),
                            ),
                            const SizedBox(height: 10),
                            canResendEmail
                                ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                      onPressed: sendVerificationEmail,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0038FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Resend verification link',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Galano',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('You can resend the verification link in:'),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatRemainingTime(remainingTime),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
