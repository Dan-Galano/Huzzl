import 'package:flutter/material.dart';

Widget buildCandidatesContent() {
  return Column(
    children: [
      Text(
        "Header",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Candidates Section",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("Here is some long content about candidates..."),
            ],
          ),
        ),
      ),
    ],
  );
}
