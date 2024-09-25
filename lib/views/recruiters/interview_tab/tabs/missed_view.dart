import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MissedView extends StatelessWidget {
  const MissedView({super.key});

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
          "You don't have any missed interviews.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
