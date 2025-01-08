import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';

class ReviewCongratulationPage extends StatelessWidget {
  final VoidCallback goBack;

  ReviewCongratulationPage({super.key, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/congratulations.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your review has been submitted!',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Thank you for your feedback!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 430,
                    child: BlueOutlinedBoxButton(
                      onPressed: goBack,
                      text: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
