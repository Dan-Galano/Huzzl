import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/chat/screens/chat_home.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/register/02%20verify_email.dart';
import 'package:huzzl_web/views/recruiters/register/mainHiringManager_provider.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpRecruiter extends StatefulWidget {
  SignUpRecruiter({super.key});

  @override
  State<SignUpRecruiter> createState() => _SignUpRecruiterState();
}

class _SignUpRecruiterState extends State<SignUpRecruiter> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String phoneNumberInputted = "";

  //Password toggle
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void togglePasswordConfirmVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  bool isEmailVerified = false;

  //Submit Signup Form
  void submitRegistrationRecruiter() async {
    try {
      // Show loading dialog while creating user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.transparent,
            content: Container(
              width: 105,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    Gap(10),
                    Image.asset(
                      'assets/images/gif/huzzl_loading.gif',
                      height: 100,
                      width: 100,
                    ),
                    Gap(10),
                    Text(
                      "Creating...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFfd7206),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': _email.text});

      // Send verification email
      final user = FirebaseAuth.instance.currentUser!;

      await user.sendEmailVerification();

      if (!context.mounted) return;

      // Update HiringManagerDetails
      final hiringManager =
          Provider.of<HiringManagerDetails>(context, listen: false);
      hiringManager.updateEmail(_email.text);
      hiringManager.updateFirstName(_firstName.text);
      hiringManager.updateLastName(_lastName.text);
      hiringManager.updatePassword(_password.text);
      hiringManager.updatePhone(phoneNumberInputted);
      // Close the loading dialog
      Navigator.of(context).pop();

      // Go to verify email screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return VerifyEmailRecruiter(
              userCredential: userCredential,
              email: _email.text,
              fname: _firstName.text,
              lname: _lastName.text,
              password: _password.text,
              phoneNumber: phoneNumberInputted,
            );
          },
        ),
      );

      //chattest
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => ChatHomePage()));
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog
      Navigator.of(context).pop();

      EasyLoading.showToast(
        "⚠️ ${e.message}",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      // Close the loading dialog
      Navigator.of(context).pop();

      EasyLoading.showToast(
        "An unexpected error occurred.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 600, // Set a specific width
              height: 250, // Set a specific height
              child: Card(
                color: Colors.white, // Set the card color to white
                elevation: 4, // Optional elevation for shadow effect
                margin: EdgeInsets.zero, // Remove default margin
                child: Padding(
                  padding:
                      const EdgeInsets.all(20), // Add padding inside the card
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top right close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Spacing
                      // Centered content
                      const Center(
                        child: Column(
                          children: const [
                            Text(
                              "Are you sure?",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              "Are you sure all entered information is correct?",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30), // Spacing
                      // Button centered below text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlueFilledBoxButton(
                            onPressed: () {
                              submitRegistrationRecruiter();
                            },
                            text: "Yes",
                            width: 180,
                          ),
                          GrayFilledBoxButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            text: "No",
                            width: 180,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NavBarLoginRegister(),
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Get the screen width
                  double screenWidth = constraints.maxWidth;

                  // Compute padding as a percentage of screen width
                  double paddingHorizontal =
                      screenWidth * 0.25; // Example: 10% of screen width
                  double paddingVertical = screenWidth * 0.05;

                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical),
                    child: Form(
                      key: _formKey,
                      child: ResponsiveBuilder(builder: (context, sizeInfo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "recruiter",
                                  style: TextStyle(
                                    fontFamily: "Galano",
                                    fontSize:
                                        ResponsiveSizes.titleTextSize(sizeInfo),
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0038FF),
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
                                Expanded(child: _buildGoogleSignUpButton()),
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
                                    fontSize:
                                        ResponsiveSizes.bodyTextSize(sizeInfo),
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
                            const Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            TextFormField(
                              controller: _email,
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
                                if (value!.isEmpty || value == null) {
                                  return "Email Address is required.";
                                }
                                if (!EmailValidator.validate(value)) {
                                  return "Please provide a valid email address.";
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "First Name",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _firstName,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "First name is required.";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Last Name",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _lastName,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1E1FF),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "Last name is required.";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Phone number",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            TextFormField(
                              controller: _phoneNumber,
                              maxLength: 10,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                prefixText: "+63",
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
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _password,
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
                                if (value!.isEmpty || value == null) {
                                  return "Password is required.";
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _confirmPassword,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                              ),
                              obscureText:
                                  isConfirmPasswordVisible ? false : true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      togglePasswordConfirmVisibility();
                                    },
                                    icon: isConfirmPasswordVisible
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                hintText: "Password (8 or more characters)",
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
                                if (value != _password.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
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
                                          Navigator.push(context,
                                              MaterialPageRoute(
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
                                ),
                                BlueFilledCircleButton(
                                  onPressed: () {
                                    submitForm();
                                  },
                                  text: "Create account",
                                  width: 200,
                                )
                              ],
                            )
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignUpButton() {
    return OutlinedButton.icon(
      onPressed: () => signUpWithGoogle(context),
      icon: Image.asset(
        'assets/images/google_logo.png',
        height: 24.0,
        width: 24.0,
      ),
      label: const Text(
        'Continue with Google',
        style: TextStyle(
          fontFamily: 'Galano',
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        side: const BorderSide(color: Colors.black),
      ),
    );
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    //not connected pa, for checking pa lang if the google acc is existing or available
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        EasyLoading.showToast(
          "⚠️ Google Sign-Up canceled.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String email = googleUser.email;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          await FirebaseAuth.instance.signOut();
          EasyLoading.showToast(
            "Account already exists. Please sign in.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );

          return;
        } else {
          // await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          //   'email': user.email ?? '',
          //   'name': user.displayName ?? 'No Name',
          //   'profilePicture': user.photoURL ?? '',
          //   'createdAt': FieldValue.serverTimestamp(),
          //   'role': 'jobseeker',
          // });
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1500)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
            ..textColor = Colors.white
            ..fontSize = 16.0
            ..indicatorColor = Colors.white
            ..maskColor = Colors.black.withOpacity(0.5)
            ..userInteractions = false
            ..dismissOnTap = true;
          EasyLoading.showToast(
            "Account available!",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showToast(
        "hahahaha.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      EasyLoading.showToast(
        "An unexpected error occurred. Chek your internet connection.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }
}
