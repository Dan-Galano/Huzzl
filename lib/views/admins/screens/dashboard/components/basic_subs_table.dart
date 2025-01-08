import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart'; // Import the model

class BasicSubscribersScreen extends StatelessWidget {
  const BasicSubscribersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, provider, child) {
        if (provider.basicSubscribers.isEmpty) {
          return const Center(
            child: Text(
              "No users found.",
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
                DataColumn(label: Text("Last Subscribed")),
                // DataColumn(label: Text("Expiration Date")),
                // DataColumn(label: Text("Actions")), //can edit the date (?)
              ],
              rows: provider.basicSubscribers.map((company) {
                return DataRow(cells: [
                  DataCell(Text(company.uid)),
                  DataCell(Text(company.hiringManagerFirstName)),
                  DataCell(Text(company.hiringManagerLastName)),
                  DataCell(Text(DateFormat('MMM dd, yyyy')
                      .format(company.dateSubscribed.toDate()))),
                  // DataCell(
                  //   Row(
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           //Show modal that will edit the subscription date
                  //           showEditSubscriptionModal(
                  //               context, company, provider);
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: const Color(0xffff9800),
                  //           foregroundColor: Colors.white,
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 24,
                  //             vertical: 12,
                  //           ),
                  //         ),
                  //         child: const Icon(Icons.edit),
                  //       ),
                  //       const Gap(5),
                  //       // ElevatedButton(
                  //       //   onPressed: () {
                  //       //     //Show modal that will edit the subscription date
                  //       //     showDeleteSubscriberModal(
                  //       //         context, company, provider);
                  //       //   },
                  //       //   style: ElevatedButton.styleFrom(
                  //       //     backgroundColor: const Color(0xfff44336),
                  //       //     foregroundColor: Colors.white,
                  //       //     padding: const EdgeInsets.symmetric(
                  //       //       horizontal: 24,
                  //       //       vertical: 12,
                  //       //     ),
                  //       //   ),
                  //       //   child: const Icon(Icons.delete),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
