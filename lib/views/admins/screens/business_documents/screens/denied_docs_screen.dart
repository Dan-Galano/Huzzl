import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/screens/business_documents/components/view_documents_modal.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart'; // Import the model

class DeniedDocumentsScreen extends StatelessWidget {
  const DeniedDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, provider, child) {
        if (provider.deniedCompanies.isEmpty) {
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
              rows: provider.deniedCompanies.map((company) {
                return DataRow(cells: [
                  DataCell(Text(company.companyName)),
                  DataCell(Text(company.city)),
                  DataCell(Text(company.createdAt.toDate().toString())),
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
