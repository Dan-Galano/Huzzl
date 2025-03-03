import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/views/job%20seekers/register/02%20verify_email.dart';
import 'package:huzzl_web/views/job%20seekers/register/03%20congrats.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/login/login_screen.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:responsive_builder/responsive_builder.dart';

class JobSeekerProfileScreen extends StatefulWidget {
  const JobSeekerProfileScreen({super.key});

  @override
  State<JobSeekerProfileScreen> createState() => _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState extends State<JobSeekerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String phoneNumberInputted = "";
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  bool isEmailVerified = false;

  void _registerJobSeeker() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (!isEmailVerified) {
          try {
            final user = FirebaseAuth.instance.currentUser!;
            await user.sendEmailVerification();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        }

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => EmailValidationScreen(
                    userCredential: userCredential,
                    fname: _firstNameController.text,
                    lname: _lastNameController.text,
                    email: _emailController.text,
                    phoneNumber: phoneNumberInputted,
                  )),
        );
      } on FirebaseAuthException catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error: ${e.message}")),
        // );
        EasyLoading.showToast(
          "⚠︎ ${e.message}",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
      } catch (e) {
        EasyLoading.showToast(
          "An unexpected error occurred.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Expanded(
          child: Stack(
            children: [
              NavBarLoginRegister(),
              Center(
                child: Container(
                  width: 670,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButtonback(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              iconImage: const AssetImage(
                                  'assets/images/backbutton.png'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign up your ",
                              style: TextStyle(
                                fontFamily: "Galano",
                                fontSize:
                                    ResponsiveSizes.titleTextSize(sizeInfo),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "job-seeker",
                              style: TextStyle(
                                fontFamily: "Galano",
                                fontSize:
                                    ResponsiveSizes.titleTextSize(sizeInfo),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFfe9703),
                              ),
                            ),
                            Text(
                              " account",
                              style: TextStyle(
                                fontFamily: "Galano",
                                fontSize:
                                    ResponsiveSizes.titleTextSize(sizeInfo),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'First name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff373030),
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
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
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Last name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff373030),
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
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
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone number',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff373030),
                              fontFamily: 'Galano',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixText: "+63",
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/phflag.png',
                                    width: 30,
                                  ),
                                  SizedBox(width: 8),
                                  // Text('+63', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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
                            phoneNumberInputted = "+63${value!}";
                            if (value!.isEmpty || value == null) {
                              return "Phone number is required.";
                            }
                            final RegExp phoneRegex =
                                RegExp(r'^(09|\+639)\d{9}$');
                            if (!phoneRegex.hasMatch(phoneNumberInputted)) {
                              return "Provide a valid Phone number.";
                            }
                          },
                        ),
                        const SizedBox(height: 15),
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
                          controller: _passwordController,
                          obscureText: isPasswordVisible ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                togglePasswordVisibility();
                              },
                              icon: isPasswordVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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
                            hintText: 'Password (8 or more characters)',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB6B6B6),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 8) {
                              return 'Please enter a password with 8 or more characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff373030),
                              fontFamily: 'Galano',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: isConfirmPasswordVisible ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                toggleConfirmPasswordVisibility();
                              },
                              icon: isConfirmPasswordVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    fontFamily: "Galano",
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return LoginRegister();
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "Log in",
                                    style: TextStyle(
                                      fontFamily: "Galano",
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  _registerJobSeeker();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0038FF),
                                  padding: EdgeInsets.all(20),
                                ),
                                child: const Text('Create Account',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Galano',
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
