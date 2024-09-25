import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/dialogs/mark_as_done_confirm_dialog.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:intl/intl.dart';

class MarkAsDoneDialog extends StatefulWidget {
  MarkAsDoneDialog({super.key});

  @override
  State<MarkAsDoneDialog> createState() => _MarkAsDoneDialogState();
}

class _MarkAsDoneDialogState extends State<MarkAsDoneDialog> {
  final List<String> causeOfReschedule = [
    'Interviewer unavailable',
    'Candidate requested reschedule',
    'Scheduling conflict',
    'Technical issues',
    'Interviewer emergency',
    'Candidate emergency',
    'Travel issues',
    'Meeting overrun',
    'Holiday or office closure',
    'Position details change',
    'Others'
  ];

  final List<String> interviewers = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson',
    'Emily Davis',
    'Christopher Lee',
  ];

  final List<String> interviewType = [
    'Online',
    'Face-to-face',
  ];

  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedCause;
  String? selectedInterviewer;
  String? selectedInterviewType;

  bool? _selectedOption = true;
  final _interviewFeedbackNotes = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    Future<void> _selectTimeRange() async {
      // Select start time
      final TimeOfDay? pickedStart = await showTimePicker(
        context: context,
        initialTime: selectedStartTime ?? TimeOfDay.now(),
      );
      if (pickedStart != null) {
        // Select end time
        final TimeOfDay? pickedEnd = await showTimePicker(
          context: context,
          initialTime: pickedStart.replacing(
            hour: pickedStart.hour + 1 > 23 ? 23 : pickedStart.hour + 1,
            minute: pickedStart.minute,
          ),
        );
        if (pickedEnd != null) {
          setState(() {
            selectedStartTime = pickedStart;
            selectedEndTime = pickedEnd;
          });
        }
      }
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 16,
                    ),
                    Gap(10),
                    Text(
                      'Only visible to your team',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Gap(20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xffd1e1ff),
                          foregroundColor: Color(0xff373030),
                          child: Icon(
                            Icons.person_sharp,
                            size: 60,
                          ),
                        ),
                        const Gap(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jau Salcedo',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff373030),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'jau.salcedo@gmail.com',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const Gap(4),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  'Mobile Developer',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.business_center_outlined,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  'Urdaneta City',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(MediaQuery.of(context).size.width * 0.1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //=========================== Title ===========================
                            Row(
                              children: [
                                Text("Title: "),
                                Text(
                                  "Technical Interview",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            //=========================== Interview Date ===========================
                            Gap(4),
                            Row(
                              children: [
                                Text('Interview Date: '),
                                Text(
                                  'July 17, 2024 8:00-10:00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //=========================== Interviewer/s ===========================
                            Gap(4),
                            Row(
                              children: [
                                Text('Interviewer(s): '),
                                Text(
                                  'John Wick',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //=========================== Interview Type ===========================
                            Gap(4),
                            Row(
                              children: [
                                Text('Interviewer Type: '),
                                Text(
                                  'Face-to-Face',
                                  style: TextStyle(
                                    color: Color(0xffFD7206),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //=========================== Location ===========================
                            Gap(4),
                            Row(
                              children: [
                                Text('Location: '),
                                Text(
                                  '123 Building, San Vicente, Urdaneta City, Pangasinan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //=========================== Did the candidate show up? ===========================
            const Gap(20),
            const Text(
              'Did the candidate show up?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff373030)),
            ),
            const Gap(10),
            //=========================== Radio buttons YES or NO ===========================
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _selectedOption,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                  ],
                ),
                const Gap(20), // Add some spacing between the options
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _selectedOption,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ],
            ),
            //=========================== Interview notes or comments ===========================
            const Gap(20),
            const Text(
              'Any interview notes or comments? (Optional)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff373030)),
            ),
            const Gap(20),
            TextFormField(
              controller: _interviewFeedbackNotes,
              maxLines: 10,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your feedback here...'),
            ),
            const Gap(30),
            BlueFilledCircleButton(
              onPressed: () => showConfirmMarkAsDoneDialog(context),
              text: 'Mark as done',
            )
          ],
        ),
      ),
    );
  }
}

void showMarkAsDoneDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return MarkAsDoneDialog();
    },
  );
}
