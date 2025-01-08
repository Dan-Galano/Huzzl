import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dialogs/disable_user_dialog.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dialogs/enable_user_dialog.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/widgets/downgrade_modal.dart';
import 'package:huzzl_web/views/admins/screens/manageUsers/widgets/upgrade_modal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    super.key,
  });

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  late MenuAppController adminProvider;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if data is not fetched yet

    return Consumer<MenuAppController>(
      builder: (context, menuAppController, child) {
        if (menuAppController.recentUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Users",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.6,
                  //   child: TextField(
                  //     controller: searchController,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       hintText: "Search",
                  //     ),
                  //   ),
                  // ),
                  Gap(10),
                ],
              ),
              const Gap(20),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      columns: const [
                        // DataColumn(
                        //   label: Text("UID"),
                        // ),
                        DataColumn(label: Text("Role")),
                        DataColumn(label: Text("First name")),
                        DataColumn(label: Text("Last name")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Subscription")),
                        DataColumn(label: Text("Expiration")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List.generate(
                        menuAppController.recentUsers.length,
                        (index) => recentUsers(
                            menuAppController.recentUsers[index],
                            context,
                            menuAppController),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Data row for displaying each user
DataRow recentUsers(
    RecentUser fileInfo, BuildContext context, MenuAppController controller) {
  return DataRow(
    cells: [
      // DataCell(Text(fileInfo.uid ?? 'No UID')), // Default text if null
      DataCell(
        Row(
          children: [
            Image.asset(
              fileInfo.icon ??
                  'assets/images/default-icon.png', // Default icon if null
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.role ?? 'Unknown'), // Default role if null
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.fname ?? 'No name')), // Default text if null
      DataCell(Text(fileInfo.lname ?? 'No name')), // Default text if null
      DataCell(Text(fileInfo.email ?? 'No email')), // Default text if null
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fileInfo.subscriptionType ?? 'No subscription type'),
          const Gap(5),
          if (fileInfo.subscriptionType == 'basic') ...[
            IconButton(
              iconSize: 20,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                foregroundColor: WidgetStatePropertyAll(Colors.blueAccent),
              ),
              icon: const Icon(
                  Icons.arrow_upward_rounded), // Using arrow_upward for upgrade
              onPressed: () {
                showUpgradeModal(context, fileInfo, controller);
              },
              tooltip: 'Upgrade to premium',
            ),
          ] else if (fileInfo.subscriptionType == 'premium') ...[
            IconButton(
              iconSize: 20,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                foregroundColor: WidgetStatePropertyAll(Colors.redAccent),
              ),
              icon: const Icon(Icons
                  .arrow_downward_rounded), // Using arrow_upward for upgrade
              onPressed: () {
                showDowngradeModal(context, fileInfo, controller);
              },
              tooltip: 'Change to basic',
            ),
          ]
        ],
      )), // Default text if null
      if (fileInfo.subscriptionType == 'premium') ...[
        DataCell(Text(DateFormat('MM/dd/yyyy').format(
            fileInfo.dateSubscribed!.toDate().add(const Duration(days: 30))))),
      ] else if (fileInfo.subscriptionType == 'basic') ...[
        const DataCell(Text('N/A')),
      ] else ...[
        const DataCell(Text('N/A')),
      ],
      DataCell(Text(fileInfo.status ?? 'No status')), // Default text if null
      DataCell(
        Row(
          children: [
            if (fileInfo.status != "enabled") ...[
              ElevatedButton(
                onPressed: () {
                  print(fileInfo.uid);
                  print(fileInfo.email);
                  showEnableUserDialog(
                      context, fileInfo.email!, fileInfo.uid!, controller);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                child: const Text('Enable'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  print(fileInfo.uid);
                  print(fileInfo.email);
                  showDisableUserDialog(
                      context, fileInfo.email!, fileInfo.uid!, controller);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                child: const Text('Disable'),
              ),
            ]
          ],
        ),
      ),
    ],
  );
}
