import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/customCheckbox.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/customDropdown.dart';

class FilterRowWidget extends StatefulWidget {
  @override
  _FilterRowWidgetState createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  String selectedBranch = 'All branches';
  String selectedJob = 'All jobs';
  String selectedSort = 'Newest-Oldest';

  bool isFullTime = false;
  bool isPartTime = false;
  bool isPermanent = false;
  bool isFixedTerm = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          buildCustomDropdown<String>(
            value: selectedBranch,
            items: <String>[
              'All branches',
              'Urdaneta Branch',
              'Dagupan Branch',
              'San Carlos Branch'
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedBranch = newValue!;
              });
            },
          ),
          SizedBox(width: 10),
          buildCustomDropdown<String>(
            value: selectedJob,
            items: <String>['All jobs', 'Vocalist', 'Dancerist', 'Tiktokerist'],
            onChanged: (String? newValue) {
              setState(() {
                selectedJob = newValue!;
              });
            },
          ),
          SizedBox(width: 10),
          buildCustomDropdown<String>(
            value: selectedSort,
            items: <String>['Newest-Oldest', 'Oldest-Newest', 'A-Z', 'Z-A'],
            onChanged: (String? newValue) {
              setState(() {
                selectedSort = newValue!;
              });
            },
          ),
          SizedBox(width: 20),
          Row(
            children: [
              buildCustomCheckbox(
                value: isFullTime,
                label: 'Full-time',
                onChanged: (bool? newValue) {
                  setState(() {
                    isFullTime = newValue!;
                  });
                },
              ),
              Gap(15),
              buildCustomCheckbox(
                value: isPartTime,
                label: 'Part-time',
                onChanged: (bool? newValue) {
                  setState(() {
                    isPartTime = newValue!;
                  });
                },
              ),
              Gap(15),
              buildCustomCheckbox(
                value: isPermanent,
                label: 'Permanent',
                onChanged: (bool? newValue) {
                  setState(() {
                    isPermanent = newValue!;
                  });
                },
              ),
              Gap(15),
              buildCustomCheckbox(
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9), width: 2),
        borderRadius: BorderRadius.circular(10), // Rounded border
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
            child: Text(
              value.toString(),
              style: TextStyle(fontFamily: 'Galano'),
            ),
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
