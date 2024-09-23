import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/contacted_card.dart';

class ContactedView extends StatelessWidget {
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
          child: ListView(
            children: [
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
              ContactedCard(),
            ],
          ),
        ),
      ],
    );
  }
}
