import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/company_profile_v2.dart';
import 'package:huzzl_web/views/recruiters/register/sample.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class PhoneNumberVerification extends StatefulWidget {
  UserCredential userCredential;
  final String phoneNumber;

  PhoneNumberVerification({
    required this.phoneNumber,
    required this.userCredential,
  });

  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode(); // Automatically send OTP when the screen loads
  }

  void _sendVerificationCode() async {
    setState(() {
      _isCodeSent = false;
      _isLoading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in with the credential
        await _linkPhoneNumberWithCredential(credential);
        _navigateToNextScreen(); // Automatically navigate if credential is valid
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error, show a message to the user
        print('Verification failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Try again later.')),
        );
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID for later use
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Code sent to ${widget.phoneNumber}')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout handling
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _submitCode() async {
    setState(() {
      _isLoading = true;
    });

    // Get the entered code
    String enteredCode =
        _controllers.map((controller) => controller.text).join();

    if (_verificationId != null) {
      try {
        // Create a PhoneAuthCredential using the verification ID and entered code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: enteredCode,
        );

        // Link the phone number with the current user account
        await _linkPhoneNumberWithCredential(credential);

        // Navigate to the next screen if sign-in is successful
        _navigateToNextScreen();
      } catch (e) {
        // Handle error (e.g. invalid code)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid code. Please try again.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _linkPhoneNumberWithCredential(
      PhoneAuthCredential credential) async {
    User? currentUser = _auth.currentUser;

    try {
      // If a user is already signed in, link the phone credential with the existing account
      if (currentUser != null) {
        await currentUser.linkWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number linked successfully!')),
        );
      } else {
        // If no user is signed in, sign in with the phone credential
        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      print('Error linking phone number: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error linking phone number: ${e.message}')),
      );
    }
  }

  void _navigateToNextScreen() {
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompanyProfileRecruiter(
          userCredential: widget.userCredential,
        ),
      ),
    );
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.7,
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
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/validation_logo.png',
                              height: 85,
                            ),
                            // const Text(
                            //   'Verify Your Account',
                            //   style: TextStyle(
                            //     fontSize: 30,
                            //     fontWeight: FontWeight.bold,
                            //     fontFamily: 'Galano',
                            //   ),
                            // ),
                            Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Verify your phone number',
                                        style: const TextStyle(
                                          fontFamily: 'Galano',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // TextSpan(
                                      //   text: ' Email',
                                      //   style: const TextStyle(
                                      //     fontFamily: 'Galano',
                                      //     fontSize: 25,
                                      //     color: Color(0xffFD7206),
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                      // TextSpan(
                                      //   text: '.',
                                      //   style: const TextStyle(
                                      //     fontFamily: 'Galano',
                                      //     fontSize: 25,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Please enter the send code to *** **** *789',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Galano',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // Align start
                              children: List.generate(6, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          20.0), // Adjust horizontal spacing
                                  child: SizedBox(
                                    width: 30,
                                    child: TextField(
                                      controller: _controllers[index],
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      decoration: const InputDecoration(
                                        counterText: '',
                                      ),
                                      onChanged: (value) {
                                        // Automatically focus next textfield
                                        if (value.isNotEmpty && index < 5) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                        // Go back to the previous field on backspace
                                        else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       // sendVerificationEmail();
                            //       setState(() {
                            //         // canResendEmail = false;
                            //       });
                            //       // resendEmail();
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color(0xFF0038FF),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(5),
                            //       ),
                            //       elevation: 5,
                            //     ),
                            //     child: const Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Icon(
                            //           Icons
                            //               .email, // Replace with the desired icon
                            //           color: Colors.white,
                            //         ),
                            //         SizedBox(width: 10),
                            //         Text(
                            //           'Resent Email',
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontFamily: 'Galano',
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // )
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                        "It may take a minute to receive your code."),
                                    Row(
                                      children: [
                                        const Text("Haven't received it?"),
                                        TextButton(
                                          onPressed: () {},
                                          child:
                                              const Text("Resend a new code"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                BlueFilledCircleButton(
                                  onPressed: () {
                                    _submitCode();
                                  },
                                  text: "Submit",
                                  width: 150,
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
// appBar: AppBar(title: Text('Phone Verification')),
      // body: _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               _isCodeSent
      //                   ? 'Enter the code sent to ${widget.phoneNumber}'
      //                   : 'Sending verification code...',
      //               textAlign: TextAlign.center,
      //             ),
      //             if (_isCodeSent)
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(vertical: 20.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: List.generate(6, (index) {
      //                     return SizedBox(
      //                       width: 40,
      //                       child: TextField(
      //                         controller: _controllers[index],
      //                         textAlign: TextAlign.center,
      //                         keyboardType: TextInputType.number,
      //                         maxLength: 1,
      //                         decoration: InputDecoration(
      //                           counterText: '',
      //                           enabledBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(color: Colors.black87),
      //                           ),
      //                           focusedBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(color: Colors.blue),
      //                           ),
      //                         ),
      //                         onChanged: (value) {
      //                           // Automatically focus next textfield
      //                           if (value.isNotEmpty && index < 5) {
      //                             FocusScope.of(context).nextFocus();
      //                           }
      //                           // Go back to the previous field on backspace
      //                           else if (value.isEmpty && index > 0) {
      //                             FocusScope.of(context).previousFocus();
      //                           }
      //                         },
      //                       ),
      //                     );
      //                   }),
      //                 ),
      //               ),
      //             if (_isCodeSent)
      //               ElevatedButton(
      //                 onPressed: _submitCode,
      //                 child: Text('Submit Code'),
      //               ),
      //           ],
      //         ),
      //       ),