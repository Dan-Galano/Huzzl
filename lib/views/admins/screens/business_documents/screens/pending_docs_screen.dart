import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class PendingDocumentsScreen extends StatefulWidget {
  const PendingDocumentsScreen({
    super.key,
  });

  @override
  State<PendingDocumentsScreen> createState() => _PendingDocumentsScreenState();
}

class _PendingDocumentsScreenState extends State<PendingDocumentsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if data is not fetched yet

    return Consumer<MenuAppController>(
      builder: (context, menuAppController, child) {
        if (menuAppController.recentUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: const [
                      // DataColumn(
                      //   label: Text("UID"),
                      // ),
                      DataColumn(label: Text("Company")),
                      DataColumn(label: Text("Date Uploaded")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: List.generate(
                      3,
                      (index) => dataRowBusinessDocument(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Data row for displaying each company that had submitted their business document
DataRow dataRowBusinessDocument() {
  return DataRow(
    cells: [
      // DataCell(Text(fileInfo.uid ?? 'No UID')), // Default text if null
      DataCell(Text('Company name unavailable')), // Default text if null
      DataCell(Text('No name')), // Default text if null
      DataCell(
        ElevatedButton(
          onPressed: () {
            //showCompanyInfoDialog();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          child: const Text('View Documents'),
        ),
      ),
    ],
  );
}
