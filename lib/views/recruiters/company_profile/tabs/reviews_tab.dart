import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:huzzl_web/views/recruiters/company_profile/reviews_details.dart';
import 'package:provider/provider.dart';


class ReviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProfileProvider>(
        builder: (context, provider, child) {
        return Column(
          children: [
            Gap(5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Company Reviews",
                    style: TextStyle(
                      color: Color(0xff202855),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Galano',
                    ),
                  ),
                ],
              ),
            ),
           ReviewsListView(reviews: provider.reviews)
        
          ],
        );
      }
    );
  }
}
