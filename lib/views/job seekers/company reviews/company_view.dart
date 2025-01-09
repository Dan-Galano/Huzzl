import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_reviews.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/profile_header.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/tabs/about_tab.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/tabs/reviews_tab.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/recruiters/company_profile/profile_header.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabbar.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabs/about_tab.dart';
import 'package:huzzl_web/views/recruiters/company_profile/tabs/reviews_tab.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:provider/provider.dart';

class CompanyViewScreen extends StatefulWidget {
  final String recruiterId;
  final bool showReviewBtn;

  const CompanyViewScreen({Key? key, required this.recruiterId, required this.showReviewBtn})
      : super(key: key);

  @override
  State<CompanyViewScreen> createState() => _CompanyViewScreenState();
}

class _CompanyViewScreenState extends State<CompanyViewScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> fetchCompanyDetails() async {
    try {
      final compProvider =
          Provider.of<CompanyProfileProvider>(context, listen: false);
      await compProvider.fetchCompanyDetails(widget.recruiterId);
      await compProvider.fetchAllReviews(widget.recruiterId);
    } catch (e) {
      print("error: $e");
    }
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
                  ProfileHeaderJobSeeker(
                    recruiterId: widget.recruiterId,
                    showReviewBtn: widget.showReviewBtn,

                  ),
                  Gap(30),
                  CompanyProfileTabBar(tabController: _tabController),
                  Container(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AboutTabJobSeeker(),
                        ReviewTabJobSeeker(),
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
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                if (userProvider.loggedInUserId == null) {
                  // Handle the case when the user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please log in first!'),
                  ));
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobseekerMainScreen(
                        uid: userProvider.loggedInUserId!,
                        selectedScreen: 1,
                      ),
                    ),
                  );
                }
              },
              iconImage: AssetImage('assets/images/backbutton.png'),
            ),
          ),
        ],
      ),
    );
  }
}
