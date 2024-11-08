import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/company_profile/details_bar.dart';
import 'package:huzzl_web/views/recruiters/company_profile/jobcards.dart';

class AboutTab extends StatelessWidget {
  final String description =
      'This is a brief description about the company and its mission. It highlights the key values, goals, and services offered.';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // CompanyProfileTabBar(tabController: _tabController),
            // Expanded(
            //   child: TabBarView(
            //     controller: _tabController,
            //     children: [
            //       AboutTab(),
            //       ReviewTab(),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 390.0),
            //   child: Row(
            //     children: [
            //       Text('About',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontFamily: 'Galano',
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black,
            //           )),
            //       SizedBox(width: 20),
            //       Text('Reviews',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontFamily: 'Galano',
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black,
            //           )),
            //     ],
            //   ),
            // ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 810,
                height: 2,
                color: Color(0xffCFCFCF),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            Gap(10),
            CompanyDetails(),
            Gap(10),
            Center(
              child: Container(
                width: 810,
                height: 2,
                color: Color(0xffCFCFCF),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            Text(
              'Jobs',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(10),
            JobSection(),
            Gap(80),
          ],
        ),
      ),
    );
  }
}
