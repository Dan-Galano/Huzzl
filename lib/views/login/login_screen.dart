import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_hinttext.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onToggle;
  LoginScreen({super.key, required this.onToggle});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        var buttonsSituation =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? Row(
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
                        onPressed: () {},
                        text: 'Login',
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlueFilledCircleButton(
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {},
                        text: 'Login',
                      ),
                    ],
                  );
        double titleFontSize =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? 32
                : 25;

        double textFieldFontSize =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? 16
                : 13;

        return Container(
          width: 670,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login your account',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: const Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: textFieldFontSize,
                        color: const Color(0xff373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LightBlueTextField(controller: emailController),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: textFieldFontSize,
                        color: const Color(0xff373030),
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
                        //onpressed
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
                  buttonsSituation,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
