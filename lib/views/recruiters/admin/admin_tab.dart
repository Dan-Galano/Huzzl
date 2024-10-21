import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/admin/views/active_view.dart';
import 'package:huzzl_web/views/recruiters/admin/views/archive_view.dart';
import 'package:huzzl_web/views/recruiters/admin/widgets/add_user_modal.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';
import 'package:responsive_builder/responsive_builder.dart';

Widget buildAdminContent(BuildContext context, userData) {
  return StatefulBuilder(
    builder: (context, setState) {
      TabController _tabController =
          TabController(length: 2, vsync: Scaffold.of(context));

      void addNewSubAdmin() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.all(20),
              insetPadding: EdgeInsets.all(20),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: MyFormModal(),
              ),
            );
          },
        );
      }

      return ResponsiveBuilder(builder: (context, sizeInfo) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double textFieldWidth = screenWidth * 0.7;
                  double spacing = screenWidth > 600 ? 20 : 10;

                  return Row(
                    children: [
                      Row(
                        children: [
                          Gap(20),
                          Text(
                            "Admin",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 32,
                              color: Color(0xff373030),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          decoration: searchTextFieldDecoration('Search'),
                        ),
                      ),
                      SizedBox(width: 20),
                      ...[
                        Icon(Icons.filter_alt),
                        SizedBox(width: 10),
                        !sizeInfo.isMobile ? Text("Filters") : SizedBox(),
                      ],
                      Spacer(),
                      !sizeInfo.isMobile
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: addNewSubAdmin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0038FF),
                                    padding: EdgeInsets.all(20),
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
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
                              ],
                            )
                          : SizedBox(),
                      SizedBox(width: 30),
                    ],
                  );
                },
              ),
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                labelStyle: const TextStyle(
                  fontSize: 14, // Font size of the selected tab
                  fontWeight:
                      FontWeight.bold, // Font weight of the selected tab
                  fontFamily: 'Galano', // Use your custom font
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12, // Font size of the unselected tabs
                  fontWeight:
                      FontWeight.normal, // Font weight of the unselected tabs
                  fontFamily: 'Galano', // Use your custom font
                ),
                tabs: const [
                  Tab(text: '2 Active'),
                  Tab(text: '0 Archive'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Active Tab Content
                    CompanyAdminsActive(userData: userData),

                    // Archive Tab Content
                    CompanyAdminsArchive(userData: userData),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
