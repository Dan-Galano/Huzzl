

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: PhoneVerificationWidget()),
    );
  }
}


class PhoneVerificationService {
  final String accountSid = 'AC5f8fa163bed2a18b9476736f26fe843c';
  final String authToken = '7c33d4dd6080d1b52013fd3c5cb223b9';
  final String serviceSid = 'VA38c75772985bb97679fe474c41afa0a9';

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
        return true; // Code is correct and verified
      } else {
        print('Verification failed: Incorrect code');
        return false; // Code is incorrect
      }
    } else {
      print('Verification request failed: ${response.body}');
      return false;
    }
  }
}

class PhoneVerificationWidget extends StatefulWidget {
  @override
  _PhoneVerificationWidgetState createState() =>
      _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final PhoneVerificationService _service = PhoneVerificationService();
  
  Timer? _timer;
  int _timeRemaining = 600; // 10 minutes in seconds
  bool _isResendButtonVisible = false;
  bool _isTimerVisible = false; 

  void _startTimer() {
  _timeRemaining = 600;
  _isResendButtonVisible = false;
  _isTimerVisible = true; // Show the timer message
  _timer?.cancel(); // Cancel any existing timer

  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      if (_timeRemaining > 0) {
        _timeRemaining--;
      } else {
        _isResendButtonVisible = true; // Show "Resend Code" button
        _isTimerVisible = false; // Hide the timer message
        _timer?.cancel();
      }
    });
  });
}

Future<void> _sendOTP() async {
  String phoneNumber = _phoneController.text.trim();
  if (phoneNumber.isNotEmpty) {
    await _service.sendOTP(phoneNumber);
    print("OTP sent to $phoneNumber");
    _startTimer();
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
      } else {
        print("Invalid OTP");
      }
    } else {
      print("Please enter the OTP");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose the timer when widget is disposed
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

 String _formatTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
  return "$minutes:$secondsRemaining";
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
            onPressed: _isResendButtonVisible ? null : _sendOTP,
            child: Text("Send OTP"),
          ),
          if (_isTimerVisible)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Time remaining: ${_formatTime(_timeRemaining)}",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          if (_isResendButtonVisible)
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text("Resend Code"),
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
