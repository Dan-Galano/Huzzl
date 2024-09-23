import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InterviewFilterRowWidget extends StatefulWidget {
  @override
  _InterviewFilterRowWidgetState createState() =>
      _InterviewFilterRowWidgetState();
}

class _InterviewFilterRowWidgetState extends State<InterviewFilterRowWidget> {
  String selectedBranch = 'All branches';
  String selectedInterviewType = 'All interview types';
  String selectedInterviewer = 'All interviewers';
  String selectedJob = 'All jobs';
  String selectedSort = 'Sort By';

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

          // For interview types
          _buildCustomDropdown<String>(
            value: selectedInterviewType,
            items: <String>['All interview types', 'Online', 'Face-to-face'],
            onChanged: (String? newValue) {
              setState(() {
                selectedInterviewType = newValue!;
              });
            },
          ),

          SizedBox(width: 10),

          // For interviewers
          _buildCustomDropdown<String>(
            value: selectedInterviewer,
            items: <String>[
              'All interviewers',
              'Patrick',
              'Dessamine',
              'Monica'
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedInterviewer = newValue!;
              });
            },
          ),

          SizedBox(width: 10),

          // Custom Dropdown for jobs
          _buildCustomDropdown<String>(
            value: selectedJob,
            items: <String>['All jobs', 'Job 1', 'Job 2'],
            onChanged: (String? newValue) {
              setState(() {
                selectedJob = newValue!;
              });
            },
          ),

          SizedBox(width: 10),

          // Custom Dropdown for sort
          _buildCustomDropdown<String>(
            value: selectedSort,
            items: <String>['Sort By', 'Date', 'Relevance'],
            onChanged: (String? newValue) {
              setState(() {
                selectedSort = newValue!;
              });
            },
          ),
          const SizedBox(width: 20),
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
}
