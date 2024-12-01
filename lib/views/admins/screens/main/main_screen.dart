import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dashboard_screen.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/manage_user.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/manage_user_old.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuController = Provider.of<MenuAppController>(context);

    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: SideMenu(),
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
        return Center(
          child: Text("Manage Job Listing tab"),
        );
      case 3:
        return Center(
          child: Text("Manage Usage Analytics tab"),
        );
      default:
        return Center(
          child: Text("Screen not found!"),
        );
    }
  }
}
