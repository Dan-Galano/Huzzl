import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/edit_user_modal.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  late MenuAppController adminProvider;
  late List<RecentUser> recentJobseeker;
  List<RecentUser>? fetchRecentJobseeker;

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<MenuAppController>(context, listen: false);
    fetchJobseeker();
  }

  // Fetch the recent jobseekers
  void fetchJobseeker() async {
    recentJobseeker = await adminProvider.fetchRecentUsers();
    setState(() {
      fetchRecentJobseeker = recentJobseeker;
    });
  }

  void editUser(
    BuildContext context,
    String uid,
    String fname,
    String lname,
    String email,
  ) {
    print("EDIT CLICKED");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit User",
                style: TextStyle(
                  fontFamily: "Galano",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: EdgeInsets.all(20),
          insetPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: EditUserModal(
                  uid: uid,
                  firstName: fname,
                  lastName: lname,
                  email: email,
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if data is not fetched yet
    if (fetchRecentJobseeker == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Registered Users",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                // DataColumn(
                //   label: Text("UID"),
                // ),
                DataColumn(
                  label: Text("Role"),
                ),
                DataColumn(
                  label: Text("First name"),
                ),
                DataColumn(
                  label: Text("Last name"),
                ),
                DataColumn(
                  label: Text("Email"),
                ),
                DataColumn(
                  label: Text("Actions"),
                ),
              ],
              rows: List.generate(
                fetchRecentJobseeker!.length,
                (index) => recentFileDataRow(
                  fetchRecentJobseeker![index],
                  () => editUser(
                    context,
                    fetchRecentJobseeker![index].uid!,
                    fetchRecentJobseeker![index].fname!,
                    fetchRecentJobseeker![index].lname!,
                    fetchRecentJobseeker![index].email!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data row for displaying each user
DataRow recentFileDataRow(RecentUser fileInfo, VoidCallback edit) {
  return DataRow(
    cells: [
      // DataCell(Text(fileInfo.uid ?? 'No UID')), // Default text if null
      DataCell(
        Row(
          children: [
            Image.asset(
              fileInfo.icon ??
                  'assets/images/default-icon.png', // Default icon if null
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.role ?? 'Unknown'), // Default role if null
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.fname ?? 'No name')), // Default text if null
      DataCell(Text(fileInfo.lname ?? 'No name')), // Default text if null
      DataCell(Text(fileInfo.email ?? 'No email')), // Default text if null
      DataCell(
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                edit();
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
            const Gap(5),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              child: const Text('Archive'),
            ),
          ],
        ),
      ),
    ],
  );
}
