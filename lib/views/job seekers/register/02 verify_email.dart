import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huzzl_web/views/recruiters/register/06%20congrats.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class EmailValidationScreen extends StatefulWidget {
  UserCredential userCredential;
  String fname;
  String lname;
  String email;
  String phoneNumber;
  EmailValidationScreen({
    required this.userCredential,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phoneNumber,
    super.key,
  });

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
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
      timer?.cancel();

      await FirebaseFirestore.instance
          .collection('jobseekers')
          .doc(widget.userCredential.user!.uid)
          .set({
        'uid': widget.userCredential.user!.uid,
        'firstName': widget.fname,
        'lastName': widget.lname,
        'email': widget.email,
        'phoneNumber': widget.phoneNumber,
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => CongratulationPage()));
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

  // final codeDigitOne = TextEditingController();
  // final codeDigitTwo = TextEditingController();
  // final codeDigitThree = TextEditingController();
  // final codeDigitFour = TextEditingController();
  // final codeDigitFive = TextEditingController();
  // final codeDigitSix = TextEditingController();

  // final focusNode1 = FocusNode();
  // final focusNode2 = FocusNode();
  // final focusNode3 = FocusNode();
  // final focusNode4 = FocusNode();
  // final focusNode5 = FocusNode();
  // final focusNode6 = FocusNode();

  // void submitValidationCode() {
  //   if (codeDigitOne.text.isEmpty ||
  //       codeDigitTwo.text.isEmpty ||
  //       codeDigitThree.text.isEmpty ||
  //       codeDigitFour.text.isEmpty ||
  //       codeDigitFive.text.isEmpty ||
  //       codeDigitSix.text.isEmpty) {
  //     print('all are required');
  //     return;
  //   }

  //   // Clear focus
  //   focusNode1.unfocus();
  //   focusNode2.unfocus();
  //   focusNode3.unfocus();
  //   focusNode4.unfocus();
  //   focusNode5.unfocus();
  //   focusNode6.unfocus();

  //   // print("goods $userInputOTP");
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const NavBarLoginRegister(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
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
                          const Text(
                            'A verification email has sent to your email address.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Click the link sent to your email address to verify your account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Galano',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CodeInputFields(
                          //         controller: codeDigitOne,
                          //         focusNode: focusNode1,
                          //         nextFocusNode: focusNode2),
                          //     const SizedBox(width: 10),
                          //     CodeInputFields(
                          //         controller: codeDigitTwo,
                          //         focusNode: focusNode2,
                          //         nextFocusNode: focusNode3),
                          //     const SizedBox(width: 10),
                          //     CodeInputFields(
                          //         controller: codeDigitThree,
                          //         focusNode: focusNode3,
                          //         nextFocusNode: focusNode4),
                          //     const SizedBox(width: 10),
                          //     CodeInputFields(
                          //         controller: codeDigitFour,
                          //         focusNode: focusNode4,
                          //         nextFocusNode: focusNode5),
                          //     const SizedBox(width: 10),
                          //     CodeInputFields(
                          //         controller: codeDigitFive,
                          //         focusNode: focusNode5,
                          //         nextFocusNode: focusNode6),
                          //     const SizedBox(width: 10),
                          //     CodeInputFields(
                          //         controller: codeDigitSix,
                          //         focusNode: focusNode6),
                          //   ],
                          // ),
                          // const SizedBox(height: 30),
                          canResendEmail
                              ? Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sendVerificationEmail();
                                    },
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         const Text(
                          //           "It may take a minute to receive your code. Haven’t received it?",
                          //           style: TextStyle(
                          //             fontFamily: 'Galano',
                          //           ),
                          //         ),
                          //         TextButton(
                          //           onPressed: () {},
                          //           child: const Text(
                          //             'Resend a new code.',
                          //             style: TextStyle(
                          //               color: Color(0xFF0038FF),
                          //               fontFamily: 'Galano',
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     ElevatedButton(
                          //       onPressed: () {
                          //         submitValidationCode();
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: const Color(0xFF0038FF),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(5),
                          //         ),
                          //         elevation: 5,
                          //       ),
                          //       child: const Text(
                          //         'SUBMIT',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontFamily: 'Galano',
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeInputFields extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const CodeInputFields({
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 30,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          fontFamily: 'Galano',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.length == 1) {
            nextFocusNode?.requestFocus();
          }
        },
      ),
    );
  }
}
