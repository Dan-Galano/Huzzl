import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/subscriber.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart'; // Import the model

class AllSubscriptionsScreen extends StatefulWidget {
  const AllSubscriptionsScreen({super.key});

  @override
  State<AllSubscriptionsScreen> createState() => _AllSubscriptionsScreenState();
}

class _AllSubscriptionsScreenState extends State<AllSubscriptionsScreen> {
  DateTime _startDate = DateTime(1999, 1, 1);
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<Subscriber> _filteredSubscriptions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _filterSubscriptions();
    });
  }

  void _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _filterSubscriptions();
      });
    }
  }

  void _pickEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _filterSubscriptions();
      });
    }
  }

  void _filterSubscriptions() {
    final provider = Provider.of<MenuAppController>(context, listen: false);
    if (_startDate != null && _endDate != null) {
      setState(() {
        _filteredSubscriptions = provider.allSubscriptions.where((subscriber) {
          final dateSubscribed = subscriber.dateSubscribed.toDate();
          return dateSubscribed.isAfter(_startDate!) &&
              dateSubscribed.isBefore(_endDate!);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuAppController>(
      builder: (context, provider, child) {
        if (provider.allSubscriptions.isEmpty) {
          return const Center(
            child: Text(
              "No subscribed users found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: _pickStartDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0), // Adjust padding as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          // Show label only if startTime is selected
                          if (_startDate != null)
                            Text(
                              'Start Date: ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          Text(
                            _startDate != null
                                ? DateFormat('MM/dd/yyyy').format(_startDate)
                                : 'Select Start Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: _startDate != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // ElevatedButton(
                  //   onPressed: _pickEndDate,
                  //   child: Text(_endDate == null
                  //       ? 'Select End Date'
                  //       : 'End Date: ${DateFormat('MM/dd/yyyy').format(_endDate!)}'),
                  // ),
                  InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: _pickEndDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0), // Adjust padding as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          // Show label only if startTime is selected
                          if (_endDate != null)
                            const Text(
                              'End Date: ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          Text(
                            _endDate != null
                                ? DateFormat('MM/dd/yyyy').format(_endDate)
                                : 'Select End Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: _endDate != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: const [
                    DataColumn(label: Text("User ID")),
                    DataColumn(label: Text("First Name")),
                    DataColumn(label: Text("Last Name")),
                    DataColumn(label: Text("Date Subscribed")),
                    // DataColumn(label: Text("Expiration Date")),
                    // DataColumn(label: Text("Actions")), //can edit the date (?)
                  ],
                  rows: _filteredSubscriptions.map((subscriber) {
                    return DataRow(cells: [
                      DataCell(Text(subscriber.hiringManagerFirstName)),
                      DataCell(Text(subscriber.hiringManagerLastName)),
                      DataCell(Text(subscriber.phone)),
                      DataCell(Text(DateFormat('MM/dd/yyyy')
                          .format(subscriber.dateSubscribed.toDate()))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
