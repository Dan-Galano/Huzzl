import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
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
        Tab(text: '4 For Review'),
        Tab(text: '0 Shortlisted'),
        Tab(text: '0 Contacted'),
        Tab(text: '0 Rejected'),
        Tab(text: '0 Hired'),
        Tab(text: '0 Reserved'),
      ],
    );
  }
}
