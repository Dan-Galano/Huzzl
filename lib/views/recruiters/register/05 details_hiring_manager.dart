import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class AccountHiringManagerScreen extends StatefulWidget {
  final VoidCallback previousPage;
  final TextEditingController hiringManEmailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback register;

  const AccountHiringManagerScreen({super.key, 
    required this.previousPage,
    required this.hiringManEmailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.register,
  });

  @override
  State<AccountHiringManagerScreen> createState() =>
      _AccountHiringManagerScreenState();
}

class _AccountHiringManagerScreenState
    extends State<AccountHiringManagerScreen> {
  final _formKey = GlobalKey<FormState>();

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

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Form submitted successfully'),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButtonback(
              onPressed: widget.previousPage,
              iconImage: const AssetImage('assets/images/backbutton.png'),
            ),
            const SizedBox(height: 30),
            const Text(
              "3/3",
              style: TextStyle(
                color: Color(0xffb6b6b6),
                fontFamily: 'Galano',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Complete your account',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Your account as a hiring manager',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Company Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: widget.hiringManEmailController,
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
                        return "Email is required";
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Invalid email';
                      }
                      return null;
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
                    controller: widget.passwordController,
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
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length <= 7) {
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
                    controller: widget.confirmPasswordController,
                    style: const TextStyle(
                      fontFamily: 'Galano',
                    ),
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
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != widget.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlueFilledCircleButton(
                        width: 150,
                         onPressed: () {
                          if (_formKey.currentState!.validate()) widget.register();
                        },
                        text: 'Register',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}