import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ApprovedDocumentsScreen extends StatefulWidget {
  const ApprovedDocumentsScreen({super.key});

  @override
  State<ApprovedDocumentsScreen> createState() =>
      _ApprovedDocumentsScreenState();
}

class _ApprovedDocumentsScreenState extends State<ApprovedDocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching users: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final users = snapshot.data!.docs;

            return FutureBuilder(
              future: _fetchCompanyInformation(users),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (futureSnapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error fetching company information: ${futureSnapshot.error}'),
                  );
                }

                if (futureSnapshot.hasData) {
                  final companyData =
                      futureSnapshot.data as List<Map<String, dynamic>>;

                  if (companyData.isEmpty) {
                    return const Center(
                      child: Text(
                        "No company information found.",
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
                          DataColumn(label: Text("Company")),
                          DataColumn(label: Text("City")),
                          DataColumn(label: Text("Date Uploaded")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: companyData.map((data) {
                          return DataRow(cells: [
                            DataCell(Text(data['companyName'] ?? 'N/A')),
                            DataCell(Text(data['city'] ?? 'N/A')),
                            DataCell(
                                Text(data['createdAt']?.toString() ?? 'N/A')),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Implement view document logic
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.blueAccent),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                ),
                                child: const Text('View Documents'),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            );
          } else {
            return const Center(
              child: Text(
                "No users found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCompanyInformation(
      List<QueryDocumentSnapshot> users) async {
    List<Map<String, dynamic>> companyInformationList = [];

    for (var user in users) {
      final userId = user.id;

      // Fetch company information sub-collection
      final companyInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('company_information')
          .where('companyStatus', isEqualTo: 'approved')
          .get();

      for (var companyDoc in companyInfoSnapshot.docs) {
        final data = companyDoc.data();

        companyInformationList.add({
          'companyName': data['companyName'],
          'city': data['city'],
          'createdAt': (data['created_at'] as Timestamp).toDate(),
          'businessDocuments': data['businessDocuments'],
        });
      }
    }

    return companyInformationList;
  }
}
