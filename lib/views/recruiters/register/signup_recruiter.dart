import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/02%20verify_email.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

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
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

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
    if (_formKey.currentState!.validate()) {
      try {
        //creating user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Registering..."),
                ],
              ),
            );
          },
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

        //Go to verify email
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return VerifyEmailRecruiter(
                userCredential: userCredential,
                email: _email.text,
                fname: _firstName.text,
                lname: _lastName.text,
                password: _password.text,
              );
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 550),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      const Center(
                        child: Text(
                          "Sign up your account",
                          style: TextStyle(
                            fontFamily: "Galano",
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            return "Email Address provided is not valid.";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                        obscureText: isConfirmPasswordVisible ? false : true,
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
                                  "Don't have a company account? ",
                                  style: TextStyle(
                                    fontFamily: "Galano",
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Create here.",
                                    style: TextStyle(
                                      fontFamily: "Galano",
                                      fontSize: 16,
                                      color: Color(0xFF0038FF),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          BlueFilledCircleButton(
                            onPressed: () {
                              submitRegistrationRecruiter();
                            },
                            text: "Submit",
                            width: 150,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
