import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_view.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';

class ReviewCongratulationPage extends StatelessWidget {
  final String recruiterId;
  final bool showReviewBtn;

  ReviewCongratulationPage({super.key, required this.recruiterId, required this.showReviewBtn});

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
                      onPressed: (){
                        
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CompanyViewScreen(recruiterId: recruiterId, showReviewBtn: showReviewBtn,),));
                      },
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
