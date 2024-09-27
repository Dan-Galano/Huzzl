import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_hinttext.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggle;
  LoginScreen({super.key, required this.onToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  bool isError = false;
  String errorMessage = "";

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator (or any UI indication for the loading state)
        setState(() {
          isError = false;
          errorMessage = "";
        });

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;

        if (user == null) {
          // setState(() {
          //   isError = true;
          //   errorMessage = "User not found.";
          // });
          EasyLoading.showToast(
            "⚠️ User not found.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
            // maskType: EasyLoadingMaskType.black,
          );
          return;
        }

        print('User ID: ${user.uid}');

        try {
          var userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists && userDoc.data() != null) {
            String? role = userDoc.data()?['role'];
            print("User role: $role");

            if (role != null) {
              if (role == 'jobseeker') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => JobseekerMainScreen()));
              } else if (role == 'recruiter') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => RecruiterHomeScreen()));
              }
            } else {
              print("Role is null, handling error");
            }
          } else {
            print("User document not found or data is null");
          }
        } catch (e) {
          print("Error fetching user document: $e");
        }
      } catch (e) {
        // setState(() {
        //   isError = true;
        //   errorMessage = "Invalid credentials";
        // });
        EasyLoading.showToast(
          "⚠️ Invalid credentials.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
        print('ERROR: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 670,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
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
            //ERROR MESSAGE
            isError
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
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
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == null) {
                  return "Email Address is required.";
                }
                if (!EmailValidator.validate(value)) {
                  return "Please provide a valid email address.";
                }
              },
            ),
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
            TextFormField(
              controller: passwordController,
              style: const TextStyle(
                fontFamily: 'Galano',
              ),
              obscureText: isPasswordVisible ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      togglePasswordVisibility();
                    },
                    icon: isPasswordVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off)),
                hintText: "Password (8 or more characters)",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == null) {
                  return "Password is required.";
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
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
                  onPressed: widget.onToggle,
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
      ),
    );
  }
}
