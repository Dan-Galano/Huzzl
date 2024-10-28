import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneVerificationService {
  final String accountSid = ''; //cant push sensi yung code, nasa notes ko muna
  final String authToken = '';//cant push sensi yung code, nasa notes ko muna
  final String serviceSid = '';//cant push sensi yung code, nasa notes ko muna

  Future<void> sendOTP(String phoneNumber) async {
    final url =
        Uri.parse('https://verify.twilio.com/v2/Services/$serviceSid/Verifications');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'To': phoneNumber, 'Channel': 'sms'},
    );
    if (response.statusCode == 201) {
      print('OTP sent successfully');
    } else {
      print('Failed to send OTP: ${response.body}');
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String code) async {
  final url = Uri.parse(
      'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {'To': phoneNumber, 'Code': code},
  );
  if (response.statusCode == 200) {
    return true; // Verification succeeded
  } else {
    print('Verification failed: ${response.body}');
    return false;
  }
}
}




class PhoneVerificationWidget extends StatefulWidget {
  @override
  _PhoneVerificationWidgetState createState() => _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final PhoneVerificationService _service = PhoneVerificationService();

  Future<void> _sendOTP() async {
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      await _service.sendOTP(phoneNumber);
      // Optionally show a message that OTP is sent
      print("OTP sent to $phoneNumber");
    } else {
      print("Please enter a valid phone number");
    }
  }

  Future<void> _verifyOTP() async {
    String phoneNumber = _phoneController.text.trim();
    String otpCode = _otpController.text.trim();

    if (otpCode.isNotEmpty) {
      bool isVerified = await _service.verifyOTP(phoneNumber, otpCode);
      if (isVerified) {
        print("Phone verified!");
        // Proceed with Firebase signup or next steps
      } else {
        print("Invalid OTP");
      }
    } else {
      print("Please enter the OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _sendOTP,
            child: Text("Send OTP"),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(labelText: 'Enter OTP'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _verifyOTP,
            child: Text("Verify OTP"),
          ),
        ],
      ),
    );
  }
}