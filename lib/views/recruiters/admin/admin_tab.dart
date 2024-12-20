import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/admin/views/active_view.dart';
import 'package:huzzl_web/views/recruiters/admin/views/archive_view.dart';
import 'package:huzzl_web/views/recruiters/admin/widgets/add_user_modal.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminContent extends StatefulWidget {
  final Map<String, dynamic> userData;
  final User user;

  const AdminContent({Key? key, required this.userData, required this.user})
      : super(key: key);

  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int numberOfActiveSubAdmin = 0;
  int numberOfArchivedSubAdmin = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch active and archived sub-admin counts
    fetchSubAdminCounts();
  }

  Future<void> fetchSubAdminCounts() async {
    // Fetch counts from Firestore
    final activeCount = await countSubAdmins('active');
    final archivedCount = await countSubAdmins('archived');

    setState(() {
      numberOfActiveSubAdmin = activeCount;
      numberOfArchivedSubAdmin = archivedCount;
    });
  }

  Future<int> countSubAdmins(String status) async {
    final subCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('sub_admins');

    final querySnapshot =
        await subCollectionRef.where('status', isEqualTo: status).count().get();

    // Use ?? to provide a default value of 0 if count is null
    return querySnapshot.count ?? 0;
  }

  void addNewSubAdmin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add new sub-admin",
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
          contentPadding: const EdgeInsets.all(20),
          insetPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: MyFormModal(
                user: widget.user,
                recruiterEmail: widget.userData["email"],
                recruiterPassword: widget.userData["password"],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;

                return Row(
                  children: [
                    const Text(
                      "Admin",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.4,
                    //   child: TextField(
                    //     decoration: searchTextFieldDecoration('Search'),
                    //   ),
                    // ),
                    const SizedBox(width: 20),
                    // const Row(
                    //   children: [
                    //     Icon(Icons.filter_alt),
                    //     SizedBox(width: 10),
                    //     Text("Filters"),
                    //   ],
                    // ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: addNewSubAdmin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0038FF),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/add-icon.png",
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Add sub-admin",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                );
              },
            ),
            TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              isScrollable: true,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Galano',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: 'Galano',
              ),
              tabs: [
                Tab(text: '$numberOfActiveSubAdmin Active'),
                Tab(text: '$numberOfArchivedSubAdmin Archive'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CompanyAdminsActive(
                      userData: widget.userData, user: widget.user),
                  CompanyAdminsArchive(
                      userData: widget.userData, user: widget.user),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Widget buildAdminContent(BuildContext context, userData, User user) {
//   return StatefulBuilder(
//     builder: (context, setState) {
//       TabController _tabController =
//           TabController(length: 2, vsync: Scaffold.of(context));

//       void addNewSubAdmin() {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Add new sub-admin",
//                     style: TextStyle(
//                       fontFamily: "Galano",
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               contentPadding: EdgeInsets.all(20),
//               insetPadding: EdgeInsets.all(20),
//               content: SingleChildScrollView(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   child: MyFormModal(
//                     user: user,
//                     recruiterEmail: userData["email"],
//                     recruiterPassword: userData["password"],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }

//       return ResponsiveBuilder(builder: (context, sizeInfo) {
//         return Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   double screenWidth = constraints.maxWidth;
//                   double textFieldWidth = screenWidth * 0.7;
//                   double spacing = screenWidth > 600 ? 20 : 10;

//                   return Row(
//                     children: [
//                       const Row(
//                         children: [
//                           Gap(20),
//                           Text(
//                             "Admin",
//                             style: TextStyle(
//                               decoration: TextDecoration.none,
//                               fontSize: 32,
//                               color: Color(0xff373030),
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 20),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.4,
//                         child: TextField(
//                           decoration: searchTextFieldDecoration('Search'),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       ...[
//                         Icon(Icons.filter_alt),
//                         SizedBox(width: 10),
//                         Text("Filters"),
//                       ],
//                       Spacer(),
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: addNewSubAdmin,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF0038FF),
//                               padding: const EdgeInsets.all(20),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Image.asset(
//                                   "assets/images/add-icon.png",
//                                   width: 20,
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Text(
//                                   "Add sub-admin",
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.white,
//                                     fontFamily: 'Galano',
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 30),
//                     ],
//                   );
//                 },
//               ),
//               TabBar(
//                 tabAlignment: TabAlignment.start,
//                 isScrollable: true,
//                 controller: _tabController,
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.orange,
//                 labelStyle: const TextStyle(
//                   fontSize: 14, // Font size of the selected tab
//                   fontWeight:
//                       FontWeight.bold, // Font weight of the selected tab
//                   fontFamily: 'Galano', // Use your custom font
//                 ),
//                 unselectedLabelStyle: const TextStyle(
//                   fontSize: 12, // Font size of the unselected tabs
//                   fontWeight:
//                       FontWeight.normal, // Font weight of the unselected tabs
//                   fontFamily: 'Galano', // Use your custom font
//                 ),
//                 tabs: const [
//                   Tab(text: '2 Active'),
//                   Tab(text: '0 Archive'),
//                 ],
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // Active Tab Content
//                     CompanyAdminsActive(
//                       userData: userData,
//                       user: user,
//                     ),

//                     // Archive Tab Content
//                     CompanyAdminsArchive(
//                       userData: userData,
//                       user: user,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
//     },
//   );
// }
