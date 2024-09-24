import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/managers_tab/widgets/add_new_staff_modal.dart';

//userData => user company data

Widget buildManagersContent(
    BuildContext context, userData, companyData, isStandaloneCompany) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      // Initialize the TabController inside the StatefulBuilder
      TabController _tabTwoController =
          TabController(length: 2, vsync: Scaffold.of(context));

      // List of roles
      final List<String> branches = [
        "Urdaneta",
        "Rosales",
      ];

      // List of roles
      final List<String> roles = ["Hiring manager", "staff"];

      // The currently selected role
      String? selectedRole;
      String? selectedBranches;

      void addNewStaff() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add new staff",
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
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: AddNewStaffModal(
                  isStandaloneCompany: isStandaloneCompany,
                ),
              ),
            );
          },
        );
      }

      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with title and search field
                  Row(
                    children: [
                      const Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Managers",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 32,
                              color: Color(0xff373030),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          decoration: searchTextFieldDecoration('Search'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ...[
                        Icon(Icons.filter_alt),
                        SizedBox(width: 10),
                        Text("Filters"),
                      ],
                      Spacer(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: addNewStaff,
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
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Add staff",
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
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "All Branches",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          value: selectedBranches, // Currently selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBranches = newValue;
                            });
                          },
                          items: branches
                              .map<DropdownMenuItem<String>>((String branch) {
                            return DropdownMenuItem<String>(
                              value: branch,
                              child: Text(branch),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "All Roles",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          value: selectedRole, // Currently selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRole = newValue;
                            });
                          },
                          items: roles
                              .map<DropdownMenuItem<String>>((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    controller: _tabTwoController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    labelStyle: TextStyle(
                      fontSize: 14, // Font size of the selected tab
                      fontWeight:
                          FontWeight.bold, // Font weight of the selected tab
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 12, // Font size of the unselected tabs
                      fontWeight: FontWeight
                          .normal, // Font weight of the unselected tabs
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    tabs: [
                      Tab(text: '4 Active'),
                      Tab(text: '0 Archived'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabTwoController,
                      children: [
                        // Active Tab Content
                        Center(
                          child: Text("Active"),
                        ),
                        // Archive Tab Content
                        Center(
                          child: Text("Archive"),
                        ),
                      ],
                    ),
                  ),

                  // More content can go here
                  // Text("Here is some long content about managers..."),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
