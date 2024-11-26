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
            text:
                "Candidate's adaptability and resilience stand out, showing they can thrive in dynamic environments.",
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
