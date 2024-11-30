import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/header.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/widgets/manage_jobseekerr_tab.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/widgets/manage_recruiter_tab.dart';

class ManageUsersOld extends StatefulWidget {
  const ManageUsersOld({super.key});

  @override
  State<ManageUsersOld> createState() => _ManageUsersOldState();
}

class _ManageUsersOldState extends State<ManageUsersOld>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Header(name: 'Manage Users'),
        ),
        bottom: TabBar(
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
            Tab(text: 'Recruiter'),
            Tab(text: 'Jobseeker'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //Recruiter
          ManageRecruiterTab(),
          //Jobseeker
          ManageJobseekerrTab(),
        ],
      ),
    );
  }
}
