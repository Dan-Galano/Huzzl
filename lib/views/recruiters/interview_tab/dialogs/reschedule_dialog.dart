import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:intl/intl.dart';

class RescheduleInterviewDialog extends StatefulWidget {
  RescheduleInterviewDialog({super.key});

  @override
  State<RescheduleInterviewDialog> createState() =>
      _RescheduleInterviewDialogState();
}

class _RescheduleInterviewDialogState extends State<RescheduleInterviewDialog> {
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
      content: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reschedule Interview',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ],
              ),
              const Text(
                'Note: This information will be sent to Jau Salcedo',
                style: TextStyle(
                  fontSize: 16,
                ),
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
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xffd1e1ff),
                                foregroundColor: const Color(0xff373030),
                                child: Text('A'),
                              ),
                            ],
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
                              Row(
                                children: [
                                  const Text("Title: "),
                                  const Text(
                                    "Technical Interview",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  const Text('Interview Date: '),
                                  Text(
                                    'July 17, 2024 8:00-10:00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              const Text(
                'Why do you want to reschedule this interview?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff373030)),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select reason for rescheduling",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      value: selectedCause,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCause = newValue;
                        });
                      },
                      items: causeOfReschedule
                          .map<DropdownMenuItem<String>>((String cause) {
                        return DropdownMenuItem<String>(
                          value: cause,
                          child: Text(cause),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              const Text(
                'Choose new interview date',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff373030)),
              ),
              const Gap(10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xff79747e)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'Select a date',
                          style: const TextStyle(
                            color: Color(0xff49454f),
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
              const Text(
                'Choose new interview time range',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff373030)),
              ),
              const Gap(10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _selectTimeRange,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xff79747e)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (selectedStartTime != null && selectedEndTime != null)
                              ? '${selectedStartTime!.format(context)} - ${selectedEndTime!.format(context)}'
                              : 'Select time range',
                          style: const TextStyle(
                            color: Color(0xff49454f),
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
              const Text(
                'Interviewer',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff373030)),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select interviewer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      value: selectedInterviewer,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInterviewer = newValue;
                        });
                      },
                      items: interviewers
                          .map<DropdownMenuItem<String>>((String interviewer) {
                        return DropdownMenuItem<String>(
                          value: interviewer,
                          child: Text(interviewer),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              const Text(
                'Interview Type (edit pa ito for multiple selection)',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff373030)),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select interview type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      value: selectedInterviewType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInterviewType = newValue;
                        });
                      },
                      items: interviewType
                          .map<DropdownMenuItem<String>>((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              BlueFilledCircleButton(onPressed: () {}, text: 'Reschedule')
            ],
          ),
        ),
      ),
    );
  }
}

void showRescheduleInterviewDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return RescheduleInterviewDialog();
    },
  );
}
