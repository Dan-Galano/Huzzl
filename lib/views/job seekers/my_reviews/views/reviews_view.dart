import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyReviews extends StatelessWidget {
  MyReviews({super.key});

  final List myReviews = [];

  @override
  Widget build(BuildContext context) {
    if (myReviews.isNotEmpty) {
      return const Center(
        child: Text('Your reviews will appear here.'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 140,
          ),
          const Gap(20),
          const Text(
            "You don't have any saved jobs.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }
}
