import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart'; // Import the model

class AllSubscriptionsScreen extends StatelessWidget {
  const AllSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, provider, child) {
        if (provider.allSubscriptions.isEmpty) {
          return const Center(
            child: Text(
              "No subscribed users found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(label: Text("User ID")),
                DataColumn(label: Text("First Name")),
                DataColumn(label: Text("Last Name")),
                DataColumn(label: Text("Date Subscribed")),
                // DataColumn(label: Text("Expiration Date")),
                // DataColumn(label: Text("Actions")), //can edit the date (?)
              ],
              rows: provider.allSubscriptions.map((company) {
                return DataRow(cells: [
                  DataCell(Text(company.uid)),
                  DataCell(Text(company.hiringManagerFirstName)),
                  DataCell(Text(company.hiringManagerLastName)),
                  DataCell(Text(DateFormat('MMM dd, yyyy')
                      .format(company.dateSubscribed.toDate()))),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
