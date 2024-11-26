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
                "Their dedication to excellence and strong work ethic distinguish them as a standout applicant. The candidate showcases a creative approach to challenges, with a proven ability to think outside the box.",
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
