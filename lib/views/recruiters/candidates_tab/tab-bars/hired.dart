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
    if (widget.candidates.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 140,
          ),
          const Gap(20),
          const Text(
            " No hires yet. Once candidates are hired for this job, they'll appear here.\nStart reviewing and selecting top talent to build your team!",
            textAlign: TextAlign.center,
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
            child: ListView.builder(
              itemCount: widget.candidates.length,
              itemBuilder: (context, index) => HiredCard(
                candidate: widget.candidates[index],
              ),
            ),
          ),
        ],
      );
    }
  }
}

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: widget.candidates.length,
          //     itemBuilder: (context, index) => ContactedCard(
          //       candidate: widget.candidates[index],
          //     ),
          //   ),
          // ),
