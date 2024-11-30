import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';

class CloseAccountDialog extends StatefulWidget {
  const CloseAccountDialog({super.key});

  @override
  State<CloseAccountDialog> createState() => _CloseAccountDialogState();
}

class _CloseAccountDialogState extends State<CloseAccountDialog> {
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible; // Toggle visibility
    });
  }

  // Show a loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Loading, please wait...',
        );
      },
    );
  }

  // Close account method
  void _closeAccount(BuildContext context, User user, String password) async {
    try {
      _showLoadingDialog(context);
      // Reauthenticate the user before closing the account
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password, // Use the provided password from the TextField
      );

      // Reauthenticate the user
      await user.reauthenticateWithCredential(credential);

      // Proceed with deleting the account after reauthentication
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete(); // Delete the user's document from Firestore

      await user.delete(); // Delete the user from Firebase Authentication

      // Show success message and navigate back to login screen
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Color.fromARGB(255, 55, 148, 53)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;

      EasyLoading.showToast(
        "Account closed successfully! Thank you for using Huzzl!",
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginRegister(), // Redirect to the login page
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      print('Error during reauthentication or user deletion: $e');

      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Color(0xFfd74a4a)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;

      EasyLoading.showToast(
        "Invalid Password.",
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        height: 300,
        child: Card(
          color: Colors.white,
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                Center(
                  child: Column(
                    children: const [
                      Text(
                        "Close account? Are you sure?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Galano',
                        ),
                      ),
                      Text(
                        "This wil delete all your data and you need to create a new account again",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Galano',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Spacing
                // Password input field
                Center(
                  child: Container(
                    width: 470,
                    child: TextField(
                      controller: _passwordController,
                      obscureText:
                          !isPasswordVisible, // This controls visibility
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: togglePasswordVisibility,
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
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
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Spacing
                // Button centered below text
                Center(
                  child: BlueFilledCircleButton(
                    onPressed: () {
                      String password = _passwordController.text;
                      if (password.isNotEmpty) {
                        _closeAccount(context,
                            FirebaseAuth.instance.currentUser!, password);
                      } else {
                        EasyLoading.instance
                          ..displayDuration = const Duration(milliseconds: 1500)
                          ..indicatorType =
                              EasyLoadingIndicatorType.fadingCircle
                          ..loadingStyle = EasyLoadingStyle.custom
                          ..backgroundColor = Color(0xFfd74a4a)
                          ..textColor = Colors.white
                          ..fontSize = 16.0
                          ..indicatorColor = Colors.white
                          ..maskColor = Colors.black.withOpacity(0.5)
                          ..userInteractions = false
                          ..dismissOnTap = true;

                        EasyLoading.showToast(
                          "Please enter your password.",
                          toastPosition: EasyLoadingToastPosition.top,
                          duration: Duration(seconds: 2),
                        );
                      }
                    },
                    text: "Close", // Button text
                    width: 470, // Optional width for the button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
