import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/contacted_card.dart';

class ContactedView extends StatefulWidget {
  List<Candidate> candidates;
  ContactedView({super.key, required this.candidates});

  @override
  State<ContactedView> createState() => _ContactedViewState();
}

class _ContactedViewState extends State<ContactedView> {
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
            "Looks like you have not interviewed any applicants yet.",
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Interview Count",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Galano',
                  ),
                ),
                Gap(40),
                Text(
                  "Last Interviewed",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Galano',
                  ),
                ),
                Gap(430),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.candidates.length,
              itemBuilder: (context, index) => ContactedCard(
                candidate: widget.candidates[index],
              ),
            ),
          ),
        ],
      );
    }
  }
}
