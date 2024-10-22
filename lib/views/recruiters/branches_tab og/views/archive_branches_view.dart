import 'package:flutter/material.dart';

class ArchiveBranchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Archived Branches',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}
