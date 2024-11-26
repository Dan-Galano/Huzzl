import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/rejected_card.dart';

class RejectedView extends StatefulWidget {
  List<Candidate> candidates;
  RejectedView({super.key, required this.candidates});

  @override
  State<RejectedView> createState() => _RejectedViewState();
}

class _RejectedViewState extends State<RejectedView> {
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
            "Looks like you have not rejected any applicants yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
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
              itemBuilder: (context, index) => RejectedCard(
                candidate: widget.candidates[index],
              ),
            ),
          ),
      ],
    );
  }
}
