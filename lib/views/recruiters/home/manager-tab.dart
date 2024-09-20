import 'package:flutter/material.dart';

Widget buildManagersContent(context) {
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
                              contentPadding: EdgeInsets.all(20),
                              insetPadding: EdgeInsets.all(20),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: MyFormModal(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
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
                          DataCell(Text("Patrick John")),
                          DataCell(Text("Tomas")),
                          DataCell(Text("Admin")),
                          DataCell(Text("patrickjohntomas0228@gmail.com")),
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

          SizedBox(height: 20),

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
  @override
  _MyFormModalState createState() => _MyFormModalState();
}

class _MyFormModalState extends State<MyFormModal> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Wrap the TextFormField with Expanded to make it responsive
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                ),
              ),
              const SizedBox(width: 20), // Space between the fields
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
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
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                Navigator.pop(context); // Close the modal
                print('Email: $_email, Password: $_password');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
