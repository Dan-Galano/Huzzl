import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class ValidationScreen extends StatelessWidget {
  ValidationScreen({super.key});

  final codeDigitOne = TextEditingController();
  final codeDigitTwo = TextEditingController();
  final codeDigitThree = TextEditingController();
  final codeDigitFour = TextEditingController();
  final codeDigitFive = TextEditingController();
  final codeDigitSix = TextEditingController();

  void submitValidationCode() {
    // print(codeDigitOne.text);

    if (codeDigitOne.text.isEmpty ||
        codeDigitTwo.text.isEmpty ||
        codeDigitThree.text.isEmpty ||
        codeDigitFour.text.isEmpty ||
        codeDigitFive.text.isEmpty ||
        codeDigitSix.text.isEmpty) {
      print('all are required');
      return;
    }

    print("goods");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const NavBarLoginRegister(),
            Padding(
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
                        const Text(
                          'Authenticate Your Account',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Galano',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Please confirm your account by entering the authorization code sent to your email address.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Galano',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CodeInputFields(controller: codeDigitOne),
                            const SizedBox(width: 10),
                            CodeInputFields(controller: codeDigitTwo),
                            const SizedBox(width: 10),
                            CodeInputFields(controller: codeDigitThree),
                            const SizedBox(width: 10),
                            CodeInputFields(controller: codeDigitFour),
                            const SizedBox(width: 10),
                            CodeInputFields(controller: codeDigitFive),
                            const SizedBox(width: 10),
                            CodeInputFields(controller: codeDigitSix),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "It may take a minute to receive your code. Haven’t received it?",
                                  style: TextStyle(
                                    fontFamily: 'Galano',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Resend a new code.',
                                    style: TextStyle(
                                      color: Color(0xFF0038FF),
                                      fontFamily: 'Galano',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: submitValidationCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0038FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'SUBMIT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Galano',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
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
  const CodeInputFields({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 30,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          fontFamily: 'Galano',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }
}
