import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/for_review_card.dart';

class ForReviewView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 290),
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
          child: ListView(
            children: [
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
              ForReviewCard(),
            ],
          ),
        ),
      ],
    );
  }
}
