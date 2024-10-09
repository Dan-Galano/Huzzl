import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/hired_card.dart';

class HiredView extends StatefulWidget {
  List<Candidate> candidates;

  HiredView({super.key, required this.candidates});

  @override
  State<HiredView> createState() => _HiredViewState();
}

class _HiredViewState extends State<HiredView> {
  @override
  Widget build(BuildContext context) {
    if(widget.candidates.isEmpty){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 140,
          ),
          const Gap(20),
          const Text(
            "You don't have any interviews today.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    } else {
return Column(
      children: [
        Gap(5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              HiredCard(),
              HiredCard(),
              HiredCard(),
              HiredCard(),
              HiredCard(),
              HiredCard(),
              HiredCard(),
              HiredCard(),
            ],
          ),
        ),
      ],
    );

    }
      }
}
