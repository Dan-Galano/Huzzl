import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/screens/industries/components/add_industry_modal.dart';
import 'package:huzzl_web/views/admins/screens/industries/components/delete_industry_modal.dart';
import 'package:huzzl_web/views/admins/screens/industries/components/edit_industry_modal.dart';
import 'package:provider/provider.dart';

class IndustriesTable extends StatelessWidget {
  const IndustriesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(builder: (context, controller, child) {
      final industries = controller.industries;
      return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Industries",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AddIndustryDialog());
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.orangeAccent),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  tooltip: "Add Industry",
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: const [
                    DataColumn(
                      label: Text("Industry Title"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),
                  ],
                  rows: industries
                      .map((industry) => industriesDataRow(industry, context))
                      .toList()),
            ),
          ],
        ),
      );
    });
  }
}

DataRow industriesDataRow(String industry, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(industry)), // Default text if null
      DataCell(
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      EditIndustryDialog(industryToEdit: industry),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              child: const Text('Edit'),
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                showDeleteIndustryModal(context, industry);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    ],
  );
}
