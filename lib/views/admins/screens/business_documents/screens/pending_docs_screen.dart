import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/models/company_information.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/components/view_documents_modal.dart';

import '../../../constants.dart'; // Import the model

class PendingDocumentsScreen extends StatefulWidget {
  const PendingDocumentsScreen({super.key});

  @override
  State<PendingDocumentsScreen> createState() => _PendingDocumentsScreenState();
}

class _PendingDocumentsScreenState extends State<PendingDocumentsScreen> {
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
                  final companyList =
                      futureSnapshot.data as List<CompanyInformation>;

                  if (companyList.isEmpty) {
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
                        rows: companyList.map((company) {
                          return DataRow(cells: [
                            DataCell(Text(company.companyName)),
                            DataCell(Text(company.city)),
                            DataCell(
                                Text(company.createdAt.toDate().toString())),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Implement view document logic
                                  showCompanyDetailsModal(context, company);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
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

  Future<List<CompanyInformation>> _fetchCompanyInformation(
      List<QueryDocumentSnapshot> users) async {
    List<CompanyInformation> companyInformationList = [];

    for (var user in users) {
      final userId = user.id;

      // Fetch company information sub-collection
      final companyInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('company_information')
          .where('companyStatus', isEqualTo: 'pending')
          .get();

      for (var companyDoc in companyInfoSnapshot.docs) {
        final data = companyDoc.data();

        // Map Firestore document to CompanyInformation model
        companyInformationList.add(CompanyInformation(
          uid: companyDoc.id,
          companyName: data['companyName'] ?? 'N/A',
          ceoFirstName: data['ceoFirstName'] ?? 'N/A',
          ceoLastName: data['ceoLastName'] ?? 'N/A',
          industry: data['industry'] ?? 'N/A',
          companyDescription: data['companyDescription'] ?? 'N/A',
          locationOtherInformation: data['locationOtherInformation'] ?? 'N/A',
          city: data['city'] ?? 'N/A',
          region: data['region'] ?? 'N/A',
          province: data['province'] ?? 'N/A',
          createdAt: data['created_at'],
          businessDocuments: List<String>.from(data['businessDocuments'] ?? []),
          companyStatus: data['companyStatus'] ?? 'N/A',
        ));
      }
    }

    return companyInformationList;
  }
}
