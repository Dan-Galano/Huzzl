import 'package:flutter/material.dart';

class CompanyProfileTabBar extends StatelessWidget {
  final TabController tabController;

  const CompanyProfileTabBar({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color(0xff0038FF),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Galano',
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Galano',
      ),
      tabs: const [
        Tab(text: 'About'),
        Tab(text: 'Review'),
      ],
    );
  }
}
