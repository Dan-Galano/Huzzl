import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class JobApplicationPreferences extends StatefulWidget {
  // resumeAnswer: resumeAnswer,
  // onResumeAnsChange: (value) =>
  //     setState(() => resumeAnswer = value!),
  // appDeadlineAns: appDeadlineAns,
  // onAppDeadlineChange: (value) =>
  //     setState(() => appDeadlineAns = value!),
  // selectedAppDeadlineDate: appDeadlineDate,
  // onAppDeadlineDateChange: (value) =>
  //     setState(() => appDeadlineDate = value!),
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  String resumeAnswer;
  final ValueChanged<String?> onResumeAnsChanged;
  String appDeadlineAns;
  final ValueChanged<String?> onAppDeadlineAnsChanged;
  DateTime selectedAppDeadlineDate;
  final ValueChanged<DateTime?> onAppDeadlineDateChanged;

  JobApplicationPreferences(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel,
      required this.resumeAnswer,
      required this.onResumeAnsChanged,
      required this.appDeadlineAns,
      required this.onAppDeadlineAnsChanged,
      required this.selectedAppDeadlineDate,
      required this.onAppDeadlineDateChanged});

  @override
  State<JobApplicationPreferences> createState() =>
      _JobApplicationPreferencesState();
}

// enum Answer { yes, no }

class _JobApplicationPreferencesState extends State<JobApplicationPreferences> {
  final _formKey = GlobalKey<FormState>();

  // Answer? _resumeAnswer = Answer.yes;
  // Answer? _deadlineAnswer = Answer.yes;
  String _resumeAnswer = 'Yes';
  String _deadlineAnswer = 'Yes';

  // DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.selectedAppDeadlineDate) {
      setState(() {
        widget.selectedAppDeadlineDate = picked;
      });
      widget.onAppDeadlineDateChanged(picked);
    }
  }

  void _submitJobAppPref() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(40),
            Container(
              width: 860,
              height: 35,
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: widget.previousPage,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFE9703),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.2,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Preferences',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  const Text(
                    'Please provide the following to complete a job post.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Is resume required?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff202855),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Yes',
                      style: TextStyle(),
                    ),
                    leading: Radio<String>(
                      value: 'Yes',
                      groupValue: widget.resumeAnswer,
                      onChanged: (String? value) {
                        setState(() {
                          widget.resumeAnswer = value!;
                        });
                        widget.onResumeAnsChanged(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'No',
                      style: TextStyle(),
                    ),
                    leading: Radio<String>(
                      value: 'No',
                      groupValue: widget.resumeAnswer,
                      onChanged: (String? value) {
                        setState(() {
                          widget.resumeAnswer = value!;
                        });
                        widget.onResumeAnsChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Is there an application deadline?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff202855),
                    ),
                  ),
                  ListTile(
                    title: const Text('Yes'),
                    leading: Radio<String>(
                      value: 'Yes',
                      groupValue: widget.appDeadlineAns,
                      onChanged: (String? value) {
                        setState(() {
                          widget.appDeadlineAns = value!;
                        });
                        widget.onAppDeadlineAnsChanged(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading: Radio<String>(
                      value: 'No',
                      groupValue: widget.appDeadlineAns,
                      onChanged: (String? value) {
                        setState(() {
                          widget.appDeadlineAns = value!;
                        });
                        widget.onAppDeadlineAnsChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.appDeadlineAns == 'Yes')
                    Container(
                      width: 250,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black38,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                widget.selectedAppDeadlineDate == null
                                    ? 'MM/DD/YY'
                                    : DateFormat.yMMMd().format(
                                        widget.selectedAppDeadlineDate!),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(
                              Icons.date_range_outlined,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: widget.cancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xffFE9703)),
                          )),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () => _submitJobAppPref(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: const Text('Next',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
