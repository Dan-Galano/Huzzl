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
            text: "Candidate’s ability to manage multiple priorities effectively demonstrates a high level of professionalism.",
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
