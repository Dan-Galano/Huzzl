import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/homescreen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();

  Future<void> _submitOTP(BuildContext context) async {
    String otp = _otpController.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homescreen()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text("Verify Phone"),
            Gap(30),
            TextFormField(
              controller: _otpController,
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
              onPressed: () {},
              child: Text("VERIFY"),
            ),
          ],
        ),
      ),
    );
  }
}
