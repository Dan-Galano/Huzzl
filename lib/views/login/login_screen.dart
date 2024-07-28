import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_hinttext.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onToggle;
  LoginScreen({super.key, required this.onToggle});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
  final email = emailController.text;
  final password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    _showErrorDialog(context, 'Please fill in both fields.');
    return;
  }

  try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((userCredential) async {

    String userId = userCredential.user!.uid;
    print('User ID: $userId');

    DocumentSnapshot jobseekerDoc = await FirebaseFirestore.instance.collection('jobseekers').doc(userId).get();
    print('Jobseeker doc exists: ${jobseekerDoc.exists}');
    if (jobseekerDoc.exists) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => JobSeekerHomeScreen()));
      return;
    }

    DocumentSnapshot recruiterDoc = await FirebaseFirestore.instance.collection('recruiters').doc(userId).get();
    print('Recruiter doc exists: ${recruiterDoc.exists}');
    if (recruiterDoc.exists) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecruiterHomeScreen()));
      return;
    }

    _showErrorDialog(context, 'User type not found');
    });
  } catch (e) {
    _showErrorDialog(context, 'Incorrect Username and/or Password');
    print('ERROR: $e');
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  Future<void> _showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Processing...'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 670,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login your account',
            style: TextStyle(
              fontSize: 32,
              color: Color(0xff373030),
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff373030),
                fontFamily: 'Galano',
              ),
            ),
          ),
          const SizedBox(height: 8),
          LightBlueTextField(controller: emailController),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff373030),
                fontFamily: 'Galano',
              ),
            ),
          ),
          const SizedBox(height: 8),
          LightBlueHinttext(
            controller: passwordController,
            hintText: 'Password (8 or more characters)',
            obscureText: true,
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                //
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Galano',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onToggle,
                child: const Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              BlueFilledCircleButton(
                width: 150,
                onPressed: () => login(context),
                text: 'Login',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
