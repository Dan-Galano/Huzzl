

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppliedView extends StatelessWidget {
  AppliedView({super.key});

  final List myJobs = [];


  @override
  Widget build(BuildContext context) {
   if(myJobs.isNotEmpty){
      return Center(child: const Text('Job posts you applied to.'),);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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