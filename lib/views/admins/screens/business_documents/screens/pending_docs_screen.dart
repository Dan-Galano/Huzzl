import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/components/view_documents_modal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart'; // Import the model

class PendingDocumentsScreen extends StatelessWidget {
  const PendingDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, provider, child) {
        if (provider.pendingCompanies.isEmpty) {
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
              rows: provider.pendingCompanies.map((company) {
                return DataRow(cells: [
                  DataCell(Text(company.companyName)),
                  DataCell(Text(company.city)),
                  DataCell(Text(DateFormat('MM/dd/yyy')
                      .format(company.createdAt.toDate()))),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        // Implement view document logic
                        print(company.uid);
                        print(company.companyId);
                        print(company.companyStatus);

                        showCompanyDetailsModal(context, company, provider);
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
      },
    );
  }
}
