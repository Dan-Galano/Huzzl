import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuditLogTable(),
  ));
}

class AuditLogTable extends StatefulWidget {
  @override
  _AuditLogTableState createState() => _AuditLogTableState();
}

class _AuditLogTableState extends State<AuditLogTable> {
  final List<Map<String, String>> logs = [
    {
      "date": "11/10/22 at 1:44 PM",
      "user": "Maria Elisabeth",
      "action": "Logged Out",
      "message": "Session ended by the user."
    },
    {
      "date": "11/10/22 at 1:36 PM",
      "user": "Benjamin Schafer",
      "action": "Logged Out",
      "message": "Session ended by the user."
    },
    {
      "date": "11/10/22 at 1:36 PM",
      "user": "Benjamin Schafer",
      "action": "Logged In",
      "message": "User successfully logged in."
    },
    {
      "date": "11/10/22 at 1:35 PM",
      "user": "Maria Elisabeth",
      "action": "Logged In",
      "message": "User successfully logged in."
    },
    {
      "date": "11/10/22 at 1:27 PM",
      "user": "Nick Stefan",
      "action": "Sync Updated",
      "message": "User updated the synchronization settings."
    },
    {
      "date": "11/10/22 at 1:26 PM",
      "user": "Nick Stefan",
      "action": "Approved Draft",
      "message": "User approved a draft document."
    },
    {
      "date": "11/10/22 at 1:26 PM",
      "user": "Nick Stefan",
      "action": "Model Updated",
      "message": "User updated the data model."
    },
    {
      "date": "11/10/22 at 1:25 PM",
      "user": "Nick Stefan",
      "action": "Created Draft",
      "message": "User created a new draft document."
    },
    {
      "date": "11/10/22 at 1:25 PM",
      "user": "Nick Stefan",
      "action": "Approved Draft",
      "message": "User approved a draft document."
    },
    {
      "date": "11/10/22 at 1:25 PM",
      "user": "Nick Stefan",
      "action": "Created Model Column",
      "message": "User added a new column to the model."
    },
  ];

  String? selectedUser;
  String? selectedAction;

  @override
  Widget build(BuildContext context) {
    final filteredLogs = logs.where((log) {
      final matchesUser = selectedUser == null || log['user'] == selectedUser;
      final matchesAction =
          selectedAction == null || log['action'] == selectedAction;
      return matchesUser && matchesAction;
    }).toList();

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 50, right: 300, left: 300),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF181818)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Audit Log",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF181818),
                    fontFamily: 'Galano',
                  ),
                ),
                Spacer(),
                Container(
                  padding:
                      const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedUser,
                    hint: const Text(
                      "Select User",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                    underline: Container(),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontSize: 12, 
                            color: Color(0xFF373030),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                      ...logs
                          .map((log) => log['user'])
                          .toSet()
                          .map<DropdownMenuItem<String>>((user) {
                        return DropdownMenuItem<String>(
                          value: user,
                          child: Container(
                            child: Text(
                              user!,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                                fontSize: 12,
                                color: Color(0xFF373030),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedUser = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedAction,
                    hint: const Text(
                      "Select Action",
                      style: TextStyle(
                        fontSize: 12, // Smaller font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF373030),
                        fontFamily: 'Galano',
                      ),
                    ),
                    underline: Container(), 
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF373030),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                      ...logs
                          .map((log) => log['action'])
                          .toSet()
                          .map<DropdownMenuItem<String>>((action) {
                        return DropdownMenuItem<String>(
                          value: action,
                          child: Text(
                            action!,
                            style: const TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 12, 
                              color: Color(0xFF373030),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    "DATE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3B7DFF),
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "USER",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3B7DFF),
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "ACTION",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3B7DFF),
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "MESSAGE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3B7DFF),
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
                color: Color.fromARGB(255, 167, 167, 167),
                thickness: 1), 

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredLogs.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color.fromARGB(255, 209, 209, 209),
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final log = filteredLogs[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                log['date']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff2C2C2C),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                log['user']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff2C2C2C),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                log['action']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff2C2C2C),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                log['message']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff2C2C2C),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
