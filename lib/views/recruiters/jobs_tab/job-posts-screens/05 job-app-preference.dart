import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class JobApplicationPreferences extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;

  const JobApplicationPreferences(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel});

  @override
  State<JobApplicationPreferences> createState() =>
      _JobApplicationPreferencesState();
}

enum Answer { yes, no }

class _JobApplicationPreferencesState extends State<JobApplicationPreferences> {
  final _formKey = GlobalKey<FormState>();

  Answer? _resumeAnswer = Answer.yes;
  Answer? _deadlineAnswer = Answer.yes;

  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitJobAppPref() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Gap(10),
                Container(
                  width: 630,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Preferences',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const Text(
                        'Please provide the following to complete a job post.',
                        style: TextStyle(
                          fontFamily: 'Galano',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Require potential candidates for a resume?',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'Galano',
                          ),
                        ),
                        leading: Radio<Answer>(
                          value: Answer.yes,
                          groupValue: _resumeAnswer,
                          onChanged: (Answer? value) {
                            setState(() {
                              _resumeAnswer = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Galano',
                          ),
                        ),
                        leading: Radio<Answer>(
                          value: Answer.no,
                          groupValue: _resumeAnswer,
                          onChanged: (Answer? value) {
                            setState(() {
                              _resumeAnswer = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Is there an application deadline?',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      ListTile(
                        title: const Text('Yes'),
                        leading: Radio<Answer>(
                          value: Answer.yes,
                          groupValue: _deadlineAnswer,
                          onChanged: (Answer? value) {
                            setState(() {
                              _deadlineAnswer = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('No'),
                        leading: Radio<Answer>(
                          value: Answer.no,
                          groupValue: _deadlineAnswer,
                          onChanged: (Answer? value) {
                            setState(() {
                              _deadlineAnswer = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_deadlineAnswer == Answer.yes)
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
                                    _selectedDate == null
                                        ? 'MM/DD/YY'
                                        : DateFormat.yMMMd()
                                            .format(_selectedDate!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Galano',
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
                                style: TextStyle(
                                    fontFamily: 'Galano',
                                    color: Color(0xffFE9703)),
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
                                  fontFamily: 'Galano',
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
        ),
      ),
    );
  }
}
