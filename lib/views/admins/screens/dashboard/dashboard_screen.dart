import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/line_chart.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/my_fields.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/subscribed_users_table.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              name: "Dashboard",
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const MyFiles(),
                      const SizedBox(height: defaultPadding),
                      Container(
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Gap(20),
                              Text(
                                'Subscribed Users',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              LineChartSample2(),
                              Gap(20),
                            ],
                          ),
                        ),
                      ),
                      //table of subsribed users and their expiration date
                      const SubscribedUsersScreen(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
