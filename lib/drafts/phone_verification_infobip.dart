
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: PhoneVerificationWidget(),
    );
  }
}

class PhoneVerificationService {
  final String apiKey =
      '76406199ea908932d41fd5be1d9e640c-13446145-f412-4675-a513-e8c0a591ef66';
  String? applicationId;
  String? messageId; // Add messageId to hold the created message template ID

  // Method to create the 2FA application
  Future<void> create2FAApplication() async {
    final url = Uri.parse('https://z34w23.api.infobip.com/2fa/2/applications');
    final headers = {
      'Authorization': 'App $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({
      "name": "Flutter 2FA App",
      "enabled": true,
      "configuration": {
        "pinAttempts": 10,
        "allowMultiplePinVerifications": true,
        "pinTimeToLive": "15m",
        "verifyPinLimit": "1/3s",
        "sendPinPerApplicationLimit": "100/1d",
        "sendPinPerPhoneNumberLimit": "10/1d"
      }
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      applicationId = responseData['applicationId'];
      print('Application ID: $applicationId'); // Debug log
    } else {
      print('Failed to create 2FA application: ${response.body}');
    }
  }

  // Method to create a message template
  Future<void> createMessageTemplate() async {
    final url = Uri.parse(
        'https://z34w23.api.infobip.com/2fa/2/applications/$applicationId/messages');
    final headers = {
      'Authorization': 'App $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "pinType": "NUMERIC",
      "messageText":
          "Your pin is {{pin}}. Hello {{firstName}}!", // Example with a placeholder
      "pinLength": 4,
      "senderId": "ServiceSMS" // Ensure this is a valid sender ID
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      messageId = responseData['messageId'];
      print("Message template created successfully with ID: $messageId");
    } else {
      print('Failed to create message template: ${response.body}');
    }
  }

  // Method to send OTP
  Future<void> sendOTP(
      BuildContext context, String phoneNumber, String firstName) async {
    if (applicationId == null) {
      _showErrorDialog(context,
          "Application ID is not set. Please create an application first.");
      return;
    }

    if (messageId == null) {
      _showErrorDialog(context,
          "Message template ID is not set. Please create a template first.");
      return;
    }

    final url =
        Uri.parse('https://z34w23.api.infobip.com/2fa/2/pin?ncNeeded=true');
    final headers = {
      'Authorization': 'App $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      "applicationId": applicationId,
      "messageId": messageId,
      "from": "ServiceSMS", // Ensure this is a valid sender ID
      "to": phoneNumber,
      "placeholders": {
        "firstName":
            firstName // Populate the firstName placeholder if used in the message
      }
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String pinId = responseData['pinId'];
      _showSuccessDialog(context, "OTP sent! Pin ID: $pinId");
    } else {
      _showErrorDialog(context, 'Failed to send OTP: ${response.body}');
    }
  }

  Future<bool> verifyOTP(
      BuildContext context, String pinId, String pinCode) async {
    final url = Uri.parse('https://z34w23.api.infobip.com/2fa/2/pin/verify');
    final headers = {
      'Authorization': 'App $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode(
        {"applicationId": applicationId, "pinId": pinId, "pin": pinCode});

    final response = await http.post(url, headers: headers, body: body);
    print("Verification response status: ${response.statusCode}");
    print("Verification response body: ${response.body}");

    if (response.statusCode == 200) {
      // Verification succeeded
      _showSuccessDialog(context, "OTP verified successfully!");
      return true;
    } else {
      // Verification failed
      _showErrorDialog(context, 'Failed to verify OTP: ${response.body}');
      return false;
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
  String? pinId; // Changed from otpId to pinId for clarity

  @override
  void initState() {
    super.initState();
    _service.create2FAApplication().then((_) {
      _service.createMessageTemplate().then((messageId) {
        // Optionally, store or use messageId for further use
      });
    });
  }

  Future<void> _sendOTP() async {
    String phoneNumber = _phoneController.text.trim();
    String firstName =
        "John"; // Replace with actual data if you want to customize the message

    if (phoneNumber.isNotEmpty) {
      await _service.sendOTP(context, phoneNumber, firstName);
    } else {
      _service._showErrorDialog(context, "Please enter a valid phone number.");
    }
  }

  Future<void> _verifyOTP() async {
    String pinCode = _otpController.text.trim();
    if (pinId != null && pinCode.isNotEmpty) {
      bool isVerified = await _service.verifyOTP(
          context, pinId!, pinCode); // Use the stored pinId
      if (isVerified) {
        // Handle successful verification (e.g., navigate to another screen)
        // You can use Navigator.pushReplacement or similar to go to the next page
        // Replace SuccessScreen with your target screen
        print("verified!!");
      }
    } else {
      _service._showErrorDialog(context, "Please enter the OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
      ),
    );
  }
}
