import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/comp_details_bar.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/write_a_reviewbtn.dart';
import 'package:huzzl_web/views/recruiters/company_profile/jobcards.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabbar.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabs/reviews_tab.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class AboutPage extends StatefulWidget {
  final Map<String, dynamic> selectedComp;

  AboutPage({Key? key, required this.selectedComp}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 390.0),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              'assets/images/banner.png',
                              height: 180.0,
                              width: 820,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: -70,
                              left: 40,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundImage: AssetImage(
                                      'assets/images/profile_huzzl.png'),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -70,
                              left: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.selectedComp['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Galano',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff202855),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 16),
                                      Text(
                                        '3.6',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 410),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 600.0), // Add padding here
                          child: WriteAReviewbtn(
                            compId: widget.selectedComp['uid'],
                            compName: widget.selectedComp['name'],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(30),
                  CompanyProfileTabBar(tabController: _tabController),
                  Container(
                    height:
                        600, // Set a fixed height to the TabBarView for scrolling
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    widget.selectedComp['description'],
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                  ),
                                ),
                                Gap(10),
                                // CompanyDetails(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CompanyInfo(
                                      iconImage:
                                          AssetImage('assets/images/CEO.png'),
                                      label: 'CEO',
                                      value: widget.selectedComp['ceoName'],
                                    ),
                                    SizedBox(width: 20),
                                    CompanyInfo(
                                      iconImage: AssetImage(
                                          'assets/images/headquarters.png'),
                                      label: 'Headquarters',
                                      value:
                                          widget.selectedComp['headquarters'],
                                    ),
                                    SizedBox(width: 40),
                                    CompanyInfo(
                                      iconImage: AssetImage(
                                          'assets/images/industry.png'),
                                      label: 'Industry',
                                      value: widget.selectedComp['industry'],
                                    ),
                                    SizedBox(width: 40),
                                    CompanyInfo(
                                      iconImage:
                                          AssetImage('assets/images/size.png'),
                                      label: 'Size',
                                      value: widget.selectedComp['compSize'],
                                    ),
                                    // SizedBox(width: 35),
                                    // CompanyInfo(
                                    //   iconImage:
                                    //       AssetImage('assets/images/link.png'),
                                    //   label: 'Website Link',
                                    //   value: widget.selectedComp['compWebsite'],
                                    // ),
                                  ],
                                ),
                                Gap(10),
                                Center(
                                  child: Container(
                                    width: 810,
                                    height: 2,
                                    color: Color(0xffCFCFCF),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
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
                        ),
                        ReviewTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 200.0,
            child: IconButtonback(
              onPressed: () {
                Navigator.pop(context);
              },
              iconImage: AssetImage('assets/images/backbutton.png'),
            ),
          ),
        ],
      ),
    );
  }
}
