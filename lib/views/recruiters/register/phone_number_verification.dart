import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/preference_view.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/register/company_profile_v2.dart';
import 'package:huzzl_web/views/recruiters/register/sample.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhoneVerificationService {
  final String accountSid = dotenv.env['TWILIO_ACCOUNT_SID'] ?? 'AC5f8fa163bed2a18b9476736f26fe843c';
  final String authToken = dotenv.env['TWILIO_AUTH_TOKEN'] ?? '01ad3003ad25a3a990bf5d138f874167';
  final String serviceSid = dotenv.env['TWILIO_SERVICE_SID'] ?? 'VA38c75772985bb97679fe474c41afa0a9';
  Future<void> sendOTP(String phoneNumber) async {
    final url = Uri.parse(
        'https://verify.twilio.com/v2/Services/$serviceSid/Verifications');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'To': phoneNumber, 'Channel': 'sms'},
    );
    if (response.statusCode == 201) {
      print('OTP sent successfully');
    } else {
      print('Failed to send OTP: ${response.body}');
      throw Exception('Failed to send OTP');
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String code) async {
    final url = Uri.parse(
        'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'To': phoneNumber, 'Code': code},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'approved') {
        return true;
      } else {
        print('Verification failed: Incorrect code');
        return false;
      }
    } else {
      print('Verification request failed: ${response.body}');
      return false;
    }
  }
}

class PhoneNumberVerification extends StatefulWidget {
  final String phoneNumber;
  UserCredential userCredential;

  PhoneNumberVerification({
    required this.phoneNumber,
    required this.userCredential,
  });

  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final PhoneVerificationService _service = PhoneVerificationService();
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<bool> _focusNodes = List.generate(6, (index) => false);
  bool _isCodeSent = false;
  bool _isLoading = false;
  // String? _verificationId;
  int _remainingSeconds = 300;
  Timer? _timer;

  String role = '';

  @override
  void initState() {
    super.initState();
    _sendOTP();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        setState(() {
          _focusNodes[i] = _controllers[i].text.isNotEmpty;
        });
      });
    }
  }

  String obscurePhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 6) return phoneNumber;
    String prefix = phoneNumber.substring(0, 4);
    String lastThreeDigits = phoneNumber.substring(phoneNumber.length - 3);
    String obscuredNumber = '$prefix** *** *$lastThreeDigits';

    return obscuredNumber;
  }

  void _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.sendOTP(widget.phoneNumber);

      setState(() {
        _isCodeSent = true;
        _isLoading = false;
        _startTimer();
      });
    } catch (error) {
      // Handle the error and show a toast
      setState(() {
        _isLoading = false;
      });

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
        "Failed to send OTP. Please try again later.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userCredential.user!.uid) 
            .delete();

        await widget.userCredential.user!.delete();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                LoginRegister(), 
          ),
        );
      } catch (e) {
        print('Error during user deletion: $e');
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
          "Error deleting user. Please try again later.",
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
      }
    }
  }

  void _startTimer() {
    _remainingSeconds = 300;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isCodeSent = false;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    String enteredCode =
        _controllers.map((controller) => controller.text).join();

    bool isVerified = await _service.verifyOTP(widget.phoneNumber, enteredCode);
    setState(() {
      _isLoading = false;
    });

    if (isVerified) {
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
        "✓ Your phone number has been verified!",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
      _navigateToNextScreen();
    } else {
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
        "⚠︎ Invalid OTP. Please try again.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
      for (var controller in _controllers) {
        controller.clear();
      }

      setState(() {
        _focusNodes = List.generate(6, (index) => false);
      });
    }
  }

  void _navigateToNextScreen() async {
    await _fetchRole();

    if (role == 'jobseeker') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PreferenceViewPage(
            userUid: widget.userCredential.user!.uid,
          ),
        ),
      );
    } else if (role == 'recruiter') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompanyProfileRecruiter(
            userCredential: widget.userCredential,
          ),
        ),
      );
    } else {
      print('Error: Invalid role. Unable to navigate.');

      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Color.fromARGB(255, 150, 31, 31)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;

      EasyLoading.showToast(
        "⚠︎ Invalid role. Unable to navigate.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> _fetchRole() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userCredential.user!.uid)
          .get();

      if (documentSnapshot.exists) {
        role = documentSnapshot.get('role') ?? '';
      } else {
        print('User document does not exist!');
      }
    } catch (e) {
      print('Error fetching role: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

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
                            Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Verify your phone number',
                                        style: TextStyle(
                                          fontFamily: 'Galano',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Please enter the code sent to ${obscurePhoneNumber(widget.phoneNumber)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: TextField(
                                        controller: _controllers[index],
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        decoration: InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: _focusNodes[index]
                                                  ? Color(0XFFfe9703)
                                                  : Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: Color(0XFFfe9703),
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty && index < 5) {
                                            FocusScope.of(context).nextFocus();
                                          } else if (value.isEmpty &&
                                              index > 0) {
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                })),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        "It may take a minute to receive your code."),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Haven't received it? "),
                                        if (_remainingSeconds > 0)
                                          Text(
                                            "$minutes:$seconds",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        else
                                          TextButton(
                                            onPressed: () {
                                              _sendOTP();
                                            },
                                            child: const Text(
                                                "Resend a new code",
                                                style: TextStyle(
                                                    color: Color(0xFFfd7911))),
                                          ),
                                      ],
                                    )
                                  ],
                                ),
                                BlueFilledCircleButton(
                                  onPressed: () {
                                    _verifyOTP();
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