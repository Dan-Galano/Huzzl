import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';
import 'package:provider/provider.dart';

class ManageRecruiterTab extends StatefulWidget {
  ManageRecruiterTab({super.key});

  @override
  State<ManageRecruiterTab> createState() => _ManageRecruiterTabState();
}

class _ManageRecruiterTabState extends State<ManageRecruiterTab> {
  late MenuAppController adminController;
  final TextEditingController searchController = TextEditingController();

  bool isSearching = false;
  String? query;

  @override
  void initState() {
    adminController = Provider.of<MenuAppController>(context, listen: false);
    super.initState();
  }

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
                    "Recruiters",
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
                      onChanged: (value) {
                        setState(() {
                          isSearching = value.isNotEmpty;
                          query = value; // Ensure lowercase for consistency
                        });
                        print("query: $query");
                      },
                    ),
                  ),
                  const Gap(10),
                ],
              ),
              const Gap(20),
              // StreamBuilder for Recruiter Data
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: isSearching
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'recruiter')
                          .where('hiringManagerFirstName', isEqualTo: query)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'recruiter')
                          .where('status', isEqualTo: 'not validated')
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
                              DataColumn(label: Text("Phone")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: recruiterDocs.map((data) {
                              final recruiterData =
                                  data.data() as Map<String, dynamic>;

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                      recruiterData['hiringManagerFirstName'] ??
                                          '')),
                                  DataCell(Text(
                                      recruiterData['hiringManagerLastName'] ??
                                          '')),
                                  const DataCell(Text("Recruiter")),
                                  DataCell(Text(recruiterData['email'] ?? '')),
                                  DataCell(Text(recruiterData['phone'] ?? '')),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'validate') {
                                          validationModal(data.id);
                                        } else if (value == 'archive') {
                                          // Implement archive functionality
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'validate',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text('Validate Business Docs'),
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

  void validationModal(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Validate Business Documents"),
          contentPadding: const EdgeInsets.all(20),
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite, // Constrain width for ListView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Text("Documents by Patrick:"),
                const SizedBox(height: 10),
                FutureBuilder<List<String>>(
                  future:
                      adminController.listFiles('BusinessDocuments/$docId/'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error loading documents"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No documents available"));
                    }

                    return SizedBox(
                      height: 300, // Specify a height for ListView
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final imageUrl = snapshot.data![index];
                          print("IMAGE: ${imageUrl}");
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image(
                              image: NetworkImage(imageUrl),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Text("Failed to load image"),
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                .expectedTotalBytes!)
                                        : null,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlueFilledBoxButton(
                  onPressed: () {},
                  text: "Accept",
                  width: 150,
                ),
                const SizedBox(width: 15),
                GrayFilledBoxButton(
                  onPressed: () {},
                  text: "Reject",
                  width: 100,
                ),
              ],
            ),
          ],
        );
      },
    );
    print("USER ID : $docId");
  }
}
