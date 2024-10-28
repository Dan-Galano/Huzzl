import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/admin/widgets/edit_subadmin_modal.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';

class CompanyAdminsArchive extends StatelessWidget {
  final dynamic userData;
  final User user;

  const CompanyAdminsArchive({
    required this.userData,
    required this.user,
    super.key,
  });

  void editSubAdmin(
    BuildContext context,
    String fname,
    String lname,
    String email,
    String phoneNumber,
    String password,
    List permissions,
    String documentId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit sub-admin",
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
              child: EditSubadminModal(
                user: user,
                firstName: fname,
                lastName: lname,
                email: email,
                password: password,
                phoneNumber: phoneNumber,
                permissions: permissions,
                documentId: documentId,
              ),
            ),
          ),
        );
      },
    );
  }

  void activateSubAdmin(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600, // Set a specific width
            height: 250, // Set a specific height
            child: Card(
              color: Colors.white, // Set the card color to white
              elevation: 4, // Optional elevation for shadow effect
              margin: EdgeInsets.zero, // Remove default margin
              child: Padding(
                padding:
                    const EdgeInsets.all(20), // Add padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top right close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Spacing
                    // Centered content
                    const Center(
                      child: Column(
                        children: const [
                          Text(
                            "Activate sub-admin?",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Galano',
                            ),
                          ),
                          Text(
                            "Are you sure you want to activate this sub-admin?",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30), // Spacing
                    // Button centered below text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlueFilledBoxButton(
                          onPressed: () {
                            activateSubAdminFunction(context, documentId);
                          },
                          text: "Yes",
                          width: 180,
                        ),
                        GrayFilledBoxButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          text: "No",
                          width: 180,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void activateSubAdminFunction(
    BuildContext context,
    String documentId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          content: Container(
            width: 105,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  const Gap(10),
                  Image.asset(
                    'assets/images/gif/huzzl_loading.gif',
                    height: 100,
                    width: 100,
                  ),
                  const Gap(10),
                  const Text(
                    "Activating sub-admin...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFfd7206),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    //Create sub-admin account
    // print("Edit form is goods: ${widget.documentId}");

    try {
      //Edit Here
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("sub_admins")
          .doc(documentId);

      await userDoc.update({
        "status": "active",
        "edited_at": DateTime.now(),
      });

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error: ${e.message}")),
      // );
      EasyLoading.showToast(
        "⚠️ ${e.message}",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
        // maskType: EasyLoadingMaskType.black,
      );
      // Navigator.pop(context);
      Navigator.of(context).pop();
    } catch (e) {
      EasyLoading.showToast(
        "An unexpected error occurred.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
        // maskType: EasyLoadingMaskType.black,
      );
      Navigator.pop(context);
    }

    // print("SUBMITTED FORM");
    // print("Permissions: $subAdminPermission");
    // print(
    //     "Data: ${_firstname.text} ${_lastname.text} ${_email.text} ${_password.text} ${_phoneNumber.text}");
  }

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
            // Container(
            //   width: double.infinity, // Take full available width
            //   child: DataTable(
            //     columnSpacing: 20,
            //     columns: const [
            //       DataColumn(label: Text("Firstname")),
            //       DataColumn(label: Text("Lastname")),
            //       DataColumn(label: Text("Role")),
            //       DataColumn(label: Text("Email")),
            //       DataColumn(label: Text("Phone")),
            //       DataColumn(label: Text("Action")),
            //     ],
            //     rows: [
            //       DataRow(
            //         selected: true,
            //         color: WidgetStateProperty.resolveWith<Color?>(
            //           (Set<WidgetState> states) {
            //             if (states.contains(WidgetState.selected)) {
            //               return Colors.green.withOpacity(0.2);
            //             }
            //             return Colors.yellow.withOpacity(0.3);
            //           },
            //         ),
            //         cells: [
            //           DataCell(Text("${userData["hiringManagerFirstName"]}")),
            //           DataCell(Text("${userData["hiringManagerLastName"]}")),
            //           DataCell(Text(
            //               userData['role'] == "recruiter" ? "Admin" : 'None')),
            //           DataCell(Text("${userData["email"]}")),
            //           DataCell(Text("${userData["phone"] ?? 'N/A'}")),
            //           DataCell(
            //             IconButton(
            //               onPressed: () async {
            //                 // Your existing logic for the icon button
            //                 final RenderBox button =
            //                     context.findRenderObject() as RenderBox;
            //                 final RenderBox overlay = Overlay.of(context)
            //                     .context
            //                     .findRenderObject() as RenderBox;

            //                 final position = button.localToGlobal(Offset.zero,
            //                     ancestor: overlay);

            //                 await showMenu(
            //                   context: context,
            //                   position: RelativeRect.fromLTRB(
            //                     position.dx,
            //                     position.dy,
            //                     overlay.size.width -
            //                         position.dx -
            //                         button.size.width,
            //                     overlay.size.height - position.dy,
            //                   ),
            //                   items: [
            //                     const PopupMenuItem(
            //                       value: 'archived',
            //                       child: Row(
            //                         children: [
            //                           Icon(Icons.feedback_outlined,
            //                               color: Colors.grey),
            //                           SizedBox(width: 8),
            //                           Text('Archived'),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ).then((value) {
            //                   // Handle menu actions if needed
            //                 });
            //               },
            //               icon: Image.asset(
            //                 'assets/images/three-dot-icon-data-table.png',
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       // More rows...
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
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
                  return Center(
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.transparent,
                      content: Container(
                        width: 105,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Image.asset(
                                'assets/images/gif/huzzl_loading.gif',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Almost there...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFfd7206),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // Filter out archived sub-admins
                  final archivedRows = snapshot.data!.docs
                      .map((data) {
                        final documentId = data.id;
                        final subAdminData =
                            data.data() as Map<String, dynamic>;

                        if (subAdminData['status'] != "archived") {
                          return null; // Return null if not archived
                        }

                        return DataRow(
                          cells: [
                            DataCell(
                                Text(subAdminData['subAdminFirstName'] ?? '')),
                            DataCell(
                                Text(subAdminData['subAdminLastName'] ?? '')),
                            const DataCell(Text("Sub-admin")),
                            DataCell(Text(subAdminData['subAdminEmail'] ?? '')),
                            DataCell(Text(
                                subAdminData['subAdminPhoneNumber'] ?? '')),
                            DataCell(
                              Builder(
                                builder: (BuildContext context) {
                                  return IconButton(
                                    onPressed: () async {
                                      final RenderBox button = context
                                          .findRenderObject() as RenderBox;
                                      final RenderBox overlay =
                                          Overlay.of(context)
                                              .context
                                              .findRenderObject() as RenderBox;
                                      final Offset position =
                                          button.localToGlobal(Offset.zero,
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
                                        items: const [
                                          PopupMenuItem(
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
                                          PopupMenuItem(
                                            value: 'activate',
                                            child: Row(
                                              children: [
                                                Icon(Icons.feedback_outlined,
                                                    color: Colors.grey),
                                                SizedBox(width: 8),
                                                Text('Activate'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).then((value) {
                                        if (value == "edit") {
                                          editSubAdmin(
                                            context,
                                            subAdminData['subAdminFirstName'] ??
                                                '',
                                            subAdminData['subAdminLastName'] ??
                                                '',
                                            subAdminData['subAdminEmail'] ?? '',
                                            subAdminData[
                                                    'subAdminPhoneNumber'] ??
                                                '',
                                            subAdminData['subAdminPassword'] ??
                                                '',
                                            subAdminData['permissions'] ?? [],
                                            documentId,
                                          );
                                        } else if (value == "activate") {
                                          activateSubAdmin(context, documentId);
                                        }
                                      });
                                    },
                                    icon: Image.asset(
                                      'assets/images/three-dot-icon-data-table.png',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      })
                      .where((row) => row != null) // Filter out null rows
                      .cast<DataRow>() // Cast to List<DataRow>
                      .toList();

                  // Only display DataTable if there are archived rows
                  if (archivedRows.isNotEmpty) {
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
                        rows: archivedRows,
                      ),
                    );
                  } else {
                    // Display message if there are no archived rows
                    return const Center(
                      child: Text(
                        "No archived sub-admins to display.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                } else {
                  // Display message if no sub-admins exist at all
                  return const Center(
                    child: Text(
                      "You have not added any sub-admins yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
