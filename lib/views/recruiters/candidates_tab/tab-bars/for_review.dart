import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/for_review_card.dart';

class ForReviewView extends StatefulWidget {
  List<Candidate> candidates;
  ForReviewView({super.key, required this.candidates});

  @override
  State<ForReviewView> createState() => _ForReviewViewState();
}

class _ForReviewViewState extends State<ForReviewView> {
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
            "You don't have any pending applicants.",
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
                Padding(
                  padding: EdgeInsets.only(right: 290),
                  child: Text(
                    "Application Date",
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
              itemBuilder: (context, index) => ForReviewCard(
                candidate: widget.candidates[index],
              ),
            ),
          ),
        ],
      );
    }
  }
}
