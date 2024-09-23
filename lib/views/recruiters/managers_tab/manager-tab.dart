import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/managers_tab/views/company_admins_active.dart';
import 'package:huzzl_web/views/recruiters/managers_tab/views/company_admins_archive.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

//userData => user company data

Widget buildManagersContent(
    BuildContext context, userData, companyData, isStandaloneCompany) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      // Initialize the TabController inside the StatefulBuilder
      TabController _tabController =
          TabController(length: 2, vsync: Scaffold.of(context));

      TabController _tabTwoController =
          TabController(length: 2, vsync: Scaffold.of(context));

      // List of roles
      final List<String> branches = [
        "Urdaneta",
        "Rosales",
      ];

      // List of roles
      final List<String> roles = [
        "admin",
        "co-admin",
        "branch manager",
        "branch -comanager"
      ];

      // The currently selected role
      String? selectedRole;
      String? selectedBranches;

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
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Add User",
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
                                            icon: const Icon(Icons
                                                .arrow_forward_ios_rounded),
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(20),
                                      insetPadding: EdgeInsets.all(20),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        child: MyFormModal(
                                          isStandaloneCompany:
                                              isStandaloneCompany,
                                        ),
                                      ),
                                      // actions: [
                                      //   TextButton(
                                      //     onPressed: () {

                                      //     },
                                      //     child: Text('Cancel'),
                                      //   ),
                                      //   ElevatedButton(
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //     },
                                      //     child: Text('Submit'),
                                      //   ),
                                      // ],
                                    );
                                  },
                                );
                              },
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Add user",
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
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    labelStyle: TextStyle(
                      fontSize: 18, // Font size of the selected tab
                      fontWeight:
                          FontWeight.bold, // Font weight of the selected tab
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16, // Font size of the unselected tabs
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
                      controller: _tabController,
                      children: [
                        // Active Tab Content
                        CompanyAdminsActive(userData: userData),
                        // Archive Tab Content
                        CompanyAdminsArchive(userData: userData),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Row(
                        children: [
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
                    controller: _tabTwoController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    labelStyle: TextStyle(
                      fontSize: 18, // Font size of the selected tab
                      fontWeight:
                          FontWeight.bold, // Font weight of the selected tab
                      fontFamily: 'Galano', // Use your custom font
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16, // Font size of the unselected tabs
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

class MyFormModal extends StatefulWidget {
  final bool isStandaloneCompany;
  const MyFormModal({required this.isStandaloneCompany, super.key});
  @override
  _MyFormModalState createState() => _MyFormModalState();
}

class _MyFormModalState extends State<MyFormModal> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  //Adding user
  String? selectedUserTitle;
  List<String> addingUsersChoices = [
    "Co-admin",
    "Branch Manager",
    "Branch co-manager",
  ];

  String? sampleSelectedBranch;
  List<String> sampleBranches = [
    "Urdaneta",
    "Rosales",
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedUserTitle,
            decoration: InputDecoration(
              labelText: 'Select role ${widget.isStandaloneCompany.toString()}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            icon: Icon(Icons.arrow_drop_down),
            isExpanded: true,
            items: addingUsersChoices.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedUserTitle = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Wrap the TextFormField with Expanded to make it responsive
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!widget.isStandaloneCompany)
            DropdownButtonFormField<String>(
              value: sampleSelectedBranch,
              decoration: InputDecoration(
                labelText: 'Select branch',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              icon: Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: sampleBranches.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  sampleSelectedBranch = newValue;
                });
              },
            ),
          if (!widget.isStandaloneCompany) const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 30),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       if (_formKey.currentState?.validate() ?? false) {
          //         _formKey.currentState?.save();
          //         Navigator.pop(context); // Close the modal
          //         print('Email: $_email, Password: $_password');
          //       }
          //     },
          //     child: Text('Submit'),
          //   ),
          // ),
          BlueFilledBoxButton(
            onPressed: () {},
            text: "Add user",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
