import 'package:flutter/material.dart';

class ApplicationNotes extends StatelessWidget {
  const ApplicationNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          style: const TextStyle(fontSize: 14),
          controller: TextEditingController(
            text: "Application notes here blabalbla blaalalal ahahah",
          ),
          maxLines: 10,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}