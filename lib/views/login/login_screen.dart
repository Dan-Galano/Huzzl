import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/Landing_Page/landing_page.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggle;
  LoginScreen({super.key, required this.onToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHovered = false;
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

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        EasyLoading.showToast(
          "Google Sign-In canceled.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) {
        EasyLoading.showToast(
          "User not found.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        return;
      }

      print("User signed in: ${user.email}, UID: ${user.uid}");

      try {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          EasyLoading.showToast(
            "This account doesn't exist. Please sign up first.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );

          // Delete the user account from Firebase Authentication
          await user
              .delete(); // This deletes the user from Firebase Authentication

          // Sign out from Google
          await GoogleSignIn().signOut();

          return;
        } else {
          String? role = userDoc.data()?['role'];
          print("User role: $role");

          if (role != null) {
            if (role == 'jobseeker') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => JobseekerMainScreen(
                        uid: user.uid,
                      )));
            } else if (role == 'recruiter') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RecruiterHomeScreen()));
            }
          } else {
            print("Role is null, handling error");
          }
        }
      } catch (e) {
        print("Error fetching user document: $e");
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      EasyLoading.showToast(
        "Google Sign-In failed: $e",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

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
            "⚠︎ User not found.",
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
                    builder: (context) => JobseekerMainScreen(
                          uid: user.uid,
                        )));
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
          "⚠︎ Invalid credentials.",
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
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Container(
        width: 500,
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSizes.paddingLarge(sizeInfo)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Log in to ',
                    style: TextStyle(
                      fontSize: ResponsiveSizes.titleTextSize(sizeInfo),
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => LandingPageNew()),
                      );
                    },
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: Text(
                        'Huzzl',
                        style: TextStyle(
                          fontSize: ResponsiveSizes.titleTextSize(sizeInfo),
                          color: _isHovered ? Colors.orange : Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
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

              Gap(30),
              Row(
                children: [
                  Expanded(child: _buildGoogleSignInButton()),
                ],
              ),
              Gap(20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Gap(20),
                  Text(
                    "or",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Gap(20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
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

                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    //
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                      color: Colors.blue,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BlueFilledCircleButton(
                      onPressed: () => login(context),
                      text: 'Log in',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // const Text(
              //   'or',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Color(0xff373030),
              //     fontFamily: 'Galano',
              //   ),
              // ),

              Gap(10),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontFamily: "Galano",
                        fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onToggle,
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: "Galano",
                          fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGoogleSignInButton() {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return OutlinedButton.icon(
        onPressed: () => signInWithGoogle(context),
        icon: Image.asset(
          'assets/images/google_logo.png',
          height: ResponsiveSizes.googlePNG(sizeInfo),
          width: ResponsiveSizes.googlePNG(sizeInfo),
        ),
        label: Text(
          'Continue with Google',
          style: TextStyle(
            fontFamily: 'Galano',
            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
            color: Colors.black,
            fontWeight: FontWeight.w100,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(
            ResponsiveSizes.submitButtonPadding(sizeInfo),
          ),
          side: const BorderSide(
            color: Color.fromARGB(255, 65, 65, 65),
            width: 0.5,
          ),
        ),
      );
    });
  }
}
