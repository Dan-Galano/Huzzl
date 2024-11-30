import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/customDropdown.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/hiring_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showHiringDialog(BuildContext context, Candidate candidate) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      DateTime? selectedDate;

      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> _selectDate() async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
            }
          }

          return Consumer<JobProviderCandidate>(
            builder: (context, jobCandidateProvider, child) {
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
                          const Text(
                            "Hiring ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            candidate.name,
                            style: const TextStyle(
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
                            candidate.profession,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Text("Send ${candidate.name} a congratulatory message!"),
                      const Gap(10),
                      InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: _selectDate,
                        child: TextField(
                          enabled: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                                : 'Select a date',
                          ),
                          decoration: const InputDecoration(
                            enabled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                await jobCandidateProvider.generateMessage(
                                    candidate.id, "Hire");
                              },
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
                          text: jobCandidateProvider.hireMessage,
                        ),
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 16),
                                backgroundColor:
                                    Color.fromARGB(255, 180, 180, 180),
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
                              onPressed: () {
                                if(selectedDate == null && jobCandidateProvider.hireMessage.isEmpty)
                                {
                                  return;
                                }
                                showHiringConfirmationDialog(
                                    context, candidate, selectedDate!, jobCandidateProvider.hireMessage);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 16),
                                backgroundColor: const Color(0xFF157925),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Hire this applicant',
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
    },
  );
}
