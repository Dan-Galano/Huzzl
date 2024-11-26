import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/shortlisted_card.dart';

class ShortlistedView extends StatefulWidget {
  List<Candidate> candidates;
  ShortlistedView({super.key, required this.candidates});

  @override
  State<ShortlistedView> createState() => _ShortlistedViewState();
}

class _ShortlistedViewState extends State<ShortlistedView> {
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
            "Shortlisted applicants will appear here.",
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
          const Gap(5),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 320),
                  child: Text(
                    "Shortlist Date",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.candidates.length,
              itemBuilder: (context, index) => ShortListedCard(
                candidate: widget.candidates[index],
              ),
            ),
          ),
        ],
      );
    }
  }
}
