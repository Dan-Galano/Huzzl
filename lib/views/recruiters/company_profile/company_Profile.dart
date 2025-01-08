import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/company_profile/profile_header.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabbar.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabs/about_tab.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabs/reviews_tab.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class AboutPage extends StatefulWidget {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 390.0),
              child: Column(
                children: [
                  ProfileHeader(),
                  Gap(30),
                  CompanyProfileTabBar(tabController: _tabController),
                  Container(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AboutTab(),
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
