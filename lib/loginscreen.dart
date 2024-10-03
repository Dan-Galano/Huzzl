import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/otpscreen.dart';

class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});
  TextEditingController _phoneController = TextEditingController();

  Future<void> _submitPhoneNum(BuildContext context) async {
    String phoneNum = _phoneController.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(
            e.message.toString(),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId,),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text("Phone Authentication"),
            Gap(30),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Phone Number",
              ),
            ),
            Gap(50),
            ElevatedButton(
              onPressed: () => _submitPhoneNum(context),
              child: Text("SEND OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
