import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:huzzl_web/views/admins/screens/activity_logs/activity_logs.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/business_docs.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dashboard_screen.dart';
import 'package:huzzl_web/views/admins/screens/industries/manage_industries_screen.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/manage_user.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    final menuController =
        Provider.of<MenuAppController>(context, listen: false);
    menuController.fetchRecentUsers();
    menuController.fetchCompanyInformation();
    print('Fetched users in admin (main_screen.dart)');
  }

  @override
  Widget build(BuildContext context) {
    final menuController = Provider.of<MenuAppController>(context);
    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: _getScreen(menuController.sideMenuIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return ManageUsers();
      case 2:
        return const ManageIndustriesScreen();
      case 3:
        return const ManageBusinessDocumentsScreen();
      default:
        return const Center(
          child: Text("Screen not found!"),
        );
    }
  }
}
