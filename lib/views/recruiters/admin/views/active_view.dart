import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyAdminsActive extends StatelessWidget {
  final dynamic userData;
  final User user;

  const CompanyAdminsActive({
    required this.userData,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical, // Enable vertical scrolling
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align start for full width
          children: [
            // First DataTable
            Container(
              width: double.infinity, // Take full available width
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text("Firstname")),
                  DataColumn(label: Text("Lastname")),
                  DataColumn(label: Text("Role")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Phone")),
                  DataColumn(label: Text("Action")),
                ],
                rows: [
                  DataRow(
                    selected: true,
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green.withOpacity(0.2);
                        }
                        return Colors.yellow.withOpacity(0.3);
                      },
                    ),
                    cells: [
                      DataCell(Text("${userData["hiringManagerFirstName"]}")),
                      DataCell(Text("${userData["hiringManagerLastName"]}")),
                      DataCell(Text(userData['role'] ?? '')),
                      DataCell(Text("${userData["email"]}")),
                      DataCell(Text("${userData["phone"] ?? 'N/A'}")),
                      DataCell(
                        IconButton(
                          onPressed: () async {
                            // Your existing logic for the icon button
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;

                            final position = button.localToGlobal(Offset.zero,
                                ancestor: overlay);

                            await showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                position.dx,
                                position.dy,
                                overlay.size.width -
                                    position.dx -
                                    button.size.width,
                                overlay.size.height - position.dy,
                              ),
                              items: [
                                PopupMenuItem(
                                  value: 'archived',
                                  child: Row(
                                    children: [
                                      Icon(Icons.feedback_outlined,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('Archived'),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((value) {
                              // Handle menu actions if needed
                            });
                          },
                          icon: Image.asset(
                            'assets/images/three-dot-icon-data-table.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                  // More rows...
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Spacer between tables
            const Text(
              "Sub-admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            // StreamBuilder for Sub-admins
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('sub_admins')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // Convert snapshot data to a list of maps
                  final subAdminsData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  return Container(
                    width: double.infinity, // Take full available width
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
                      rows: subAdminsData.map((subAdminData) {
                        return DataRow(
                          cells: [
                            DataCell(
                                Text(subAdminData['subAdminFirstName'] ?? '')),
                            DataCell(
                                Text(subAdminData['subAdminLastName'] ?? '')),
                            DataCell(Text((subAdminData['permissions'] as List)
                                    .join(", ") ??
                                '')),
                            DataCell(Text(subAdminData['subAdminEmail'] ?? '')),
                            DataCell(Text(
                                subAdminData['subAdminPhoneNumber'] ?? '')),
                            DataCell(
                              IconButton(
                                onPressed: () async {
                                  // Your existing logic for the icon button
                                  final RenderBox button =
                                      context.findRenderObject() as RenderBox;
                                  final RenderBox overlay = Overlay.of(context)
                                      .context
                                      .findRenderObject() as RenderBox;

                                  final position = button.localToGlobal(
                                      Offset.zero,
                                      ancestor: overlay);

                                  await showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      position.dx,
                                      position.dy,
                                      overlay.size.width -
                                          position.dx -
                                          button.size.width,
                                      overlay.size.height - position.dy,
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        value: 'archived',
                                        child: Row(
                                          children: [
                                            Icon(Icons.feedback_outlined,
                                                color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text('Archived'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).then((value) {
                                    // Handle menu actions if needed
                                  });
                                },
                                icon: Image.asset(
                                  'assets/images/three-dot-icon-data-table.png',
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  // If no sub-admins, display a message
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset("assets/images/empty_box.png", width: 140),
                      // const SizedBox(height: 20),
                      const Text(
                        "You have not added any sub-admins yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
