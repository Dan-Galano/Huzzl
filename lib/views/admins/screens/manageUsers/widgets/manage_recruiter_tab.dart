import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dialogs/disable_user_dialog.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/dialogs/enable_user_dialog.dart';
import 'package:provider/provider.dart';

class ManageRecruiterTab extends StatelessWidget {
  ManageRecruiterTab({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, adminProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Recruiter",
              //       style: TextStyle(
              //         fontSize: 25,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
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
              // Gap(10),
              // ],
              // ),
              const Gap(20),
              // StreamBuilder for Jobseeker Data
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'recruiter')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final jobseekerDocs = snapshot.data!.docs;

                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: DataTable(
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text("Role")),
                              DataColumn(label: Text("First name")),
                              DataColumn(label: Text("Last name")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Subscription")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: jobseekerDocs.map((data) {
                              final jobseekerData =
                                  data.data() as Map<String, dynamic>;

                              return DataRow(
                                cells: [
                                  DataCell(Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/company-black.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: defaultPadding),
                                        child: Text(
                                            jobseekerData['role'] == 'recruiter'
                                                ? 'Recruiter'
                                                : ''),
                                      ),
                                    ],
                                  )),
                                  DataCell(Text(
                                      jobseekerData['hiringManagerFirstName'] ??
                                          '')),
                                  DataCell(Text(
                                      jobseekerData['hiringManagerLastName'] ??
                                          '')),
                                  DataCell(Text(jobseekerData['email'] ?? '')),
                                  DataCell(Text(jobseekerData['subscriptionType'] ?? '')),
                                  DataCell(
                                      Text(jobseekerData['accStatus'] ?? '')),
                                  // DataCell(Text(jobseekerData['phone'] ?? '')),
                                  DataCell(
                                    Row(
                                      children: [
                                        if (jobseekerData['accStatus'] !=
                                            "enabled") ...[
                                          ElevatedButton(
                                            onPressed: () {
                                              showEnableUserDialog(
                                                  context,
                                                  jobseekerData['email']!,
                                                  jobseekerData['uid']!,
                                                  adminProvider);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.blueAccent),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.white),
                                              padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                              ),
                                            ),
                                            child: const Text('Enable'),
                                          ),
                                        ] else ...[
                                          ElevatedButton(
                                            onPressed: () {
                                              print(jobseekerData['uid']);
                                              print(jobseekerData['email']);
                                              showDisableUserDialog(
                                                  context,
                                                  jobseekerData['email']!,
                                                  jobseekerData['uid']!,
                                                  adminProvider);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.redAccent),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.white),
                                              padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
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
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No recruiters found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
