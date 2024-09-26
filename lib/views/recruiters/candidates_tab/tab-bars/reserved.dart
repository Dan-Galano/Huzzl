import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/reserved_card.dart';

class ReservedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
              ReservedCard(),
            ],
          ),
        ),
      ],
    );
  }
}
