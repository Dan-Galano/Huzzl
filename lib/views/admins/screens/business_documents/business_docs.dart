import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/screens/approved_docs_screen.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/screens/denied_docs_screen.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/screens/pending_docs_screen.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/header.dart';

import '../../constants.dart';

class ManageBusinessDocumentsScreen extends StatefulWidget {
  const ManageBusinessDocumentsScreen({super.key});

  @override
  State<ManageBusinessDocumentsScreen> createState() =>
      _ManageBusinessDocumentsScreenState();
}

class _ManageBusinessDocumentsScreenState
    extends State<ManageBusinessDocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              name: "Manage Business Documents",
            ),
            const SizedBox(height: defaultPadding),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.orange,
              isScrollable: true,
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
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Denied'),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  //Pending
                  PendingDocumentsScreen(),
                  //Approved
                  ApprovedDocumentsScreen(),
                  //Denied
                  DeniedDocumentsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
