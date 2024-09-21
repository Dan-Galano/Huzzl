import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

//userData => user company data

Widget buildManagersContent(
    context, userData, companyData, isStandaloneCompany) {
  // void printUserData() {
  //   print(userData);
  // }

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with title and search field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    "Managers",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Galano",
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 600,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.filter_alt),
                  SizedBox(width: 10),
                  Text("Filters"),
                ],
              ),
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
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.all(20),
                              insetPadding: EdgeInsets.all(20),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: MyFormModal(
                                  isStandaloneCompany: isStandaloneCompany,
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
            ],
          ),

          SizedBox(height: 20), // Adds space between rows

          // More content can go here
          // Text("Here is some long content about managers..."),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columnSpacing:
                        20, // Adjust this to control spacing between columns
                    columns: [
                      DataColumn(label: Text("Firstname")),
                      DataColumn(label: Text("Lastname")),
                      DataColumn(label: Text("Role")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Phone")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: [
                      DataRow(
                        selected: true,
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.green.withOpacity(0.2);
                            }
                            return Colors.yellow.withOpacity(0.3);
                          },
                        ),
                        cells: [
                          DataCell(
                              Text("${userData["hiringManagerFirstName"]}")),
                          DataCell(
                              Text("${userData["hiringManagerLastName"]}")),
                          DataCell(Text("Admin")),
                          DataCell(Text("${userData["email"]}")),
                          DataCell(Text("09483623503")),
                          DataCell(
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                  'assets/images/three-dot-icon-data-table.png'),
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Gerald")),
                          DataCell(Text("Tomas")),
                          DataCell(Text("Tomas")),
                          DataCell(Text("Tomas")),
                          DataCell(Text("Tomas")),
                          DataCell(
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                  'assets/images/three-dot-icon-data-table.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 30),

          // Example button
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: Text("Click Me"),
          //   ),
          // ),
        ],
      ),
    ),
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
