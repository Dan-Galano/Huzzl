import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/all_subs_table.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/basic_subs_table.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/line_chart.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/my_fields.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/subscribed_users_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'components/header.dart';

import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabTwoController;

  @override
  void initState() {
    super.initState();
    _tabTwoController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabTwoController.dispose();
    super.dispose();
  }

  // void _pickStartDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {});
  //     debugPrint('Start Date: $picked');
  //   }
  // }

  // void _pickEndDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {});
  //     debugPrint('End Date: $picked');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //Controller
    var adminController = Provider.of<MenuAppController>(context);
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
              children: [
                const Text('Filter by date: ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                adminController.startDate != null
                    ? Text(
                        DateFormat('MMM dd, yyyy')
                            .format(adminController.startDate!),
                        style: const TextStyle(
                          fontSize: 16,
                        ))
                    : InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: () {
                          adminController.pickStartDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 5.0), // Adjust padding as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              // Show label only if startTime is selected
                              if (adminController.startDate != null)
                                Text(
                                  'Start Date: ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              Text(
                                adminController.startDate != null
                                    ? DateFormat('MM/dd/yyyy')
                                        .format(adminController.startDate!)
                                    : 'Select Start Date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: adminController.startDate != null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const Gap(20),
                adminController.endDate != null
                    ? Text(
                        DateFormat('MMM dd, yyyy')
                            .format(adminController.endDate!),
                        style: const TextStyle(fontSize: 16))
                    : InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: () {
                          adminController.pickEndDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 5.0), // Adjust padding as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              // Show label only if startTime is selected
                              if (adminController.endDate != null)
                                const Text(
                                  'End Date: ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              Text(
                                adminController.endDate != null
                                    ? DateFormat('MM/dd/yyyy')
                                        .format(adminController.endDate!)
                                    : 'Select End Date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: adminController.endDate != null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      adminController.startDate != null &&
                              adminController.endDate != null
                          ? MyFiles(
                              startDate: adminController.startDate,
                              endDate: adminController.endDate,
                            )
                          : MyFiles(),
                      const SizedBox(height: defaultPadding),
                      Container(
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Gap(20),
                              Text(
                                'Subscriptions 2024',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              LineChartSample2(),
                              // BarChartSample2(),
                              // BarChartSample8(),
                              Gap(20),
                            ],
                          ),
                        ),
                      ),
                      //table of subsribed users
                      const SizedBox(height: defaultPadding),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Premium'),
                                Tab(text: 'Basic'),
                                Tab(text: 'All Subscriptions'),
                              ],
                            ),
                            SizedBox(
                              height: 600, // Adjust height as needed
                              child: TabBarView(
                                children: [
                                  SubscribedUsersScreen(),
                                  BasicSubscribersScreen(),
                                  adminController.startDate != null &&
                                          adminController.endDate != null
                                      ? AllSubscriptionsScreen(
                                          startDate: adminController.startDate,
                                          endDate: adminController.endDate,
                                        )
                                      : AllSubscriptionsScreen(
                                          startDate: DateTime(1999, 1, 1),
                                          endDate: DateTime.now()
                                              .add(const Duration(days: 30)),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
