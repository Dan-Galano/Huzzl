import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

class ManageJobseekerrTab extends StatefulWidget {
  const ManageJobseekerrTab({super.key});

  @override
  State<ManageJobseekerrTab> createState() => _ManageJobseekerrTabState();
}

class _ManageJobseekerrTabState extends State<ManageJobseekerrTab> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Jobseeker",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
              const Gap(20),
              // StreamBuilder for Recruiter Data
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'jobseeker')
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
                      final recruiterDocs = snapshot.data!.docs;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: DataTable(
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text("Firstname")),
                              DataColumn(label: Text("Lastname")),
                              DataColumn(label: Text("Role")),
                              DataColumn(label: Text("Email")),
                              // DataColumn(label: Text("Phone")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: recruiterDocs.map((data) {
                              final recruiterData =
                                  data.data() as Map<String, dynamic>;

                              return DataRow(
                                cells: [
                                  DataCell(
                                      Text(recruiterData['firstName'] ?? '')),
                                  DataCell(
                                      Text(recruiterData['lastName'] ?? '')),
                                  const DataCell(Text("Jobseeker")),
                                  DataCell(Text(recruiterData['email'] ?? '')),
                                  // DataCell(Text(recruiterData['phone'] ?? '')),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          // Implement edit functionality
                                        } else if (value == 'archive') {
                                          // Implement archive functionality
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'archive',
                                          child: Row(
                                            children: [
                                              Icon(Icons.archive,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text('Archive'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
