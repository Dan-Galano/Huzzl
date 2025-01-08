import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/company_profile/details_bar.dart';
import 'package:huzzl_web/views/recruiters/company_profile/jobcards.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:provider/provider.dart';

class AboutTabJobSeeker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProfileProvider>(
        builder: (context, provider, child) {
      return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  provider.companyDescription,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 910,
                  height: 2,
                  color: Color(0xffCFCFCF),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              Gap(10),
              Center(child: CompanyDetails()),
              Gap(10),
              Center(
                child: Container(
                  width: 910,
                  height: 2,
                  color: Color(0xffCFCFCF),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              // Text(
              //   'Jobs',
              //   style: TextStyle(
              //     fontFamily: 'Galano',
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // Gap(10),
              // JobSection(),
              // Gap(80),
            ],
          ),
        ),
      );
    });
  }
}
