import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/company_profile_v2.dart';
import 'package:huzzl_web/views/recruiters/register/phone_number_verification.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class VerifyEmailRecruiter extends StatefulWidget {
  UserCredential userCredential;
  String email;
  String fname;
  String lname;
  String password;
  VerifyEmailRecruiter({
    required this.userCredential,
    required this.email,
    required this.fname,
    required this.lname,
    required this.password,
    super.key,
  });

  @override
  State<VerifyEmailRecruiter> createState() => _VerifyEmailRecruiterState();
}

class _VerifyEmailRecruiterState extends State<VerifyEmailRecruiter> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }

    resendEmail();
  }

  Future resendEmail() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      canResendEmail = true;
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Verifying your email..."),
              ],
            ),
          );
        },
      );
      timer?.cancel();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userCredential.user!.uid)
          .set({
        'uid': widget.userCredential.user!.uid,
        'role': "recruiter",
        'hiringManagerFirstName': widget.fname,
        'hiringManagerLastName': widget.lname,
        'email': widget.email,
        'password': widget.password,
      });

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => CompanyProfileRecruiter(
      //       userCredential: widget.userCredential,
      //     ),
      //   ),
      // );

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => PhoneNumberVerification(
                  phoneNumber: "+63 987 867 5645",
                  userCredential: widget.userCredential,
                )),
      );
    }
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
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
                            // const Text(
                            //   'Verify Your Account',
                            //   style: TextStyle(
                            //     fontSize: 30,
                            //     fontWeight: FontWeight.bold,
                            //     fontFamily: 'Galano',
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'A verification email has sent to',
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
                                  TextSpan(
                                    text: '.',
                                    style: const TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 25,
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
                            const SizedBox(height: 20),
                            canResendEmail
                                ? Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sendVerificationEmail();
                                        setState(() {
                                          canResendEmail = false;
                                        });
                                        resendEmail();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0038FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons
                                                .email, // Replace with the desired icon
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Resent Email',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Galano',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(height: 10),
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
