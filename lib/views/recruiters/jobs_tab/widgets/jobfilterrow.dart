import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobFilterRowWidget extends StatefulWidget {
  @override
  _JobFilterRowWidgetState createState() => _JobFilterRowWidgetState();
}

class _JobFilterRowWidgetState extends State<JobFilterRowWidget> {
  String selectedBranch = 'All branches';
  bool isFullTime = false;
  bool isPartTime = false;
  bool isPermanent = false;
  bool isFixedTerm = false;

  // Date range variables
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Custom Dropdown for branches
          _buildCustomDropdown<String>(
            value: selectedBranch,
            items: <String>['All branches', 'Branch 1', 'Branch 2'],
            onChanged: (String? newValue) {
              setState(() {
                selectedBranch = newValue!;
              });
            },
          ),

          SizedBox(width: 10),

          // Date Range Picker button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(20), // Rounded border
            ),
            child: TextButton(
              onPressed: () async {
                final DateTimeRange? pickedDateRange =
                    await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDateRange: selectedDateRange,
                  builder: (BuildContext context, Widget? child) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 400, // Set the width of the dialog
                        ),
                        child: Dialog(
                          child: child,
                        ),
                      ),
                    );
                  },
                );
                if (pickedDateRange != null) {
                  setState(() {
                    selectedDateRange = pickedDateRange;
                  });
                }
              },
              child: Text(selectedDateRange == null
                  ? 'Select Date Range'
                  : '${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}'),
            ),
          ),

          SizedBox(width: 10),

          // Group of checkboxes
          Row(
            children: [
              _buildCustomCheckbox(
                value: isFullTime,
                label: 'Full-time',
                onChanged: (bool? newValue) {
                  setState(() {
                    isFullTime = newValue!;
                  });
                },
              ),
              Gap(15),
              _buildCustomCheckbox(
                value: isPartTime,
                label: 'Part-time',
                onChanged: (bool? newValue) {
                  setState(() {
                    isPartTime = newValue!;
                  });
                },
              ),
              Gap(15),
              _buildCustomCheckbox(
                value: isPermanent,
                label: 'Permanent',
                onChanged: (bool? newValue) {
                  setState(() {
                    isPermanent = newValue!;
                  });
                },
              ),
              Gap(15),
              _buildCustomCheckbox(
                value: isFixedTerm,
                label: 'Fixed Term',
                onChanged: (bool? newValue) {
                  setState(() {
                    isFixedTerm = newValue!;
                  });
                },
              ),
            ],
          ),
          Gap(40),
          Text(
            "Clear all filter",
            style: TextStyle(
              fontFamily: 'Galano',
              color: Color.fromARGB(255, 29, 116, 167),
            ),
          )
        ],
      ),
    );
  }

  // Function to create a custom dropdown with a rounded border
  Widget _buildCustomDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(20), // Rounded border
      ),
      child: DropdownButton<T>(
        value: value,
        icon: Icon(Icons.arrow_drop_down),
        underline: SizedBox(), // Remove default underline
        isExpanded: false, // Prevent the dropdown from covering itself
        style: TextStyle(color: Colors.black),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ),
    );
  }

  // Function to create a custom checkbox with a thin and rounded border
  Widget _buildCustomCheckbox({
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: Colors.white, // Color of check mark
          activeColor: Color(0xFFFF9800), // Color when checked (ff9800)
          shape: RoundedRectangleBorder(
            // Rounded shape for checkbox
            borderRadius: BorderRadius.circular(5),
          ),
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: 1, // Thin border
              color: Colors.grey,
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
