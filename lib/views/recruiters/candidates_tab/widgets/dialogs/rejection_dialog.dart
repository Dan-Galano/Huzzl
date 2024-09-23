import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/customCheckbox.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_confirm_dialog.dart';

void showRejectDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      bool isReserved = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Rejecting ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Eleanor Pena",
                        style: TextStyle(
                          color: Color(0xFFfd7206),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Icon(
                        Icons.badge,
                        size: 16,
                        color: Colors.grey.shade800,
                      ),
                      Gap(5),
                      Text(
                        'Vocalist',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                  Text("Send Eleanor a rejection notice with best wishes."),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            backgroundColor:
                                const Color.fromARGB(255, 208, 223, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Generate message',
                            style: TextStyle(
                              color: Color(0xFF3b7dff),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(30),
                  Text(
                    'Generated message will appear here. You can modify it if desired.',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Gap(10),
                  TextField(
                    style: TextStyle(fontSize: 14),
                    controller: TextEditingController(
                      text: "Sorry, bye.",
                    ),
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Gap(5),
                  buildCustomCheckbox(
                    value: isReserved,
                    label: 'Reserve this applicant for future job hiring.',
                    onChanged: (bool? newValue) {
                      setState(() {
                        isReserved = newValue!;
                      });
                    },
                  ),
                  Gap(30),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                            backgroundColor: Color.fromARGB(255, 180, 180, 180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () =>
                              showRejectConfirmationDialog(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 16),
                            backgroundColor: const Color(0xFFd74a4a),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reject this applicant',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}