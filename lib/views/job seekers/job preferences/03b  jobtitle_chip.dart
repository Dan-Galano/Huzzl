
import 'package:flutter/material.dart';

class SelectedJobTitlesWrap extends StatelessWidget {
  final List<String> selectedJobTitles;
  final Function(String) onRemoveJobTitle;

  const SelectedJobTitlesWrap({
    Key? key,
    required this.selectedJobTitles,
    required this.onRemoveJobTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: selectedJobTitles.map((title) {
        return Chip(
          label: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Galano',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xffF0F0F0), // Light background
          deleteIcon: const Icon(Icons.close, size: 18, color: Colors.black54),
          onDeleted: () => onRemoveJobTitle(title), // Handle chip deletion
        );
      }).toList(),
    );
  }
}
