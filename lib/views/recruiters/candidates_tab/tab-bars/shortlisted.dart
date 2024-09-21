import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/shortlisted_card.dart';

class ShortlistedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Branch Manager and Date Established Text
        Gap(5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 260),
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
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
              ShortListedCard(),
            ],
          ),
        ),
      ],
    );
  }
}
