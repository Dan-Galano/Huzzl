import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:provider/provider.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
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
      tabs: [
        Tab(
            text:'${branchProvider.activeBranchCount} Active'), // Active branches count

        Tab(text: '${branchProvider.archiveBranchCount} Archived'), 
      ],
    );
  }
}
