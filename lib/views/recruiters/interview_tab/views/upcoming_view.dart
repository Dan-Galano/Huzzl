import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UpcomingView extends StatelessWidget {
  const UpcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/empty_box.png",
          width: 140,
        ),
        const Gap(20),
        const Text(
          "You don't have any upcoming interviews.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
