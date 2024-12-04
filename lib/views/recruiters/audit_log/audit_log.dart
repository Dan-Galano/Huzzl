import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:provider/provider.dart';

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
  late List<Map<String, dynamic>> lateLogs = [];
  List<Map<String, dynamic>> logs = [];

  late JobProviderCandidate _jobProvider;

  @override
  void initState() {
    super.initState();
    _jobProvider = Provider.of<JobProviderCandidate>(context, listen: false);
  }

  void fetchLogs() async {
    lateLogs = await _jobProvider.fetchActivityLogs();
    setState(() {
      logs = lateLogs;
    });
    debugPrint("Logs fetch successfully");
  }

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
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF181818)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filters Row
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
                const Spacer(),

                // User Dropdown
                _buildDropdown(
                  label: "Select User",
                  value: selectedUser,
                  items: logs.map((log) => log['user']).toSet().cast<String>(),
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;
                    });
                  },
                ),

                const SizedBox(width: 10),

                // Action Dropdown
                _buildDropdown(
                  label: "Select Action",
                  value: selectedAction,
                  items:
                      logs.map((log) => log['action']).toSet().cast<String>(),
                  onChanged: (value) {
                    setState(() {
                      selectedAction = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Table Headers
            _buildTableHeaders(),

            // Divider
            const Divider(
              color: Color.fromARGB(255, 167, 167, 167),
              thickness: 1,
            ),

            // Logs Table or Empty State
            Expanded(
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        "No logs available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : _buildLogsTable(filteredLogs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required Set<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF373030),
            fontFamily: 'Galano',
          ),
        ),
        underline: Container(),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: const Text(
              "Show All",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF373030),
                fontFamily: 'Galano',
              ),
            ),
          ),
          ...items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 12,
                  color: Color(0xFF373030),
                ),
              ),
            );
          }).toList(),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTableHeaders() {
    return Row(
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
    );
  }

  Widget _buildLogsTable(List<Map<String, dynamic>> filteredLogs) {
    return SingleChildScrollView(
      child: ListView.separated(
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
    );
  }
}
