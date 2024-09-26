import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/custom_input.dart';

class JobHireSettings extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  String selectedTimeline;
  final ValueChanged<String?> onHiringTimelineChanged;

  JobHireSettings(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel,
      required this.selectedTimeline,
      required this.onHiringTimelineChanged});

  @override
  State<JobHireSettings> createState() => _JobHireSettingsState();
}

class _JobHireSettingsState extends State<JobHireSettings> {
  final _formKey = GlobalKey<FormState>();
  List<String> timelineOptions = [
    '1 to 3 days',
    '3 to 7 days',
    '1 to 2 weeks',
    '2 to 4 weeks',
    'More than 4 weeks'
  ];
  String? selectedTimeline;

  void _submitJobHireSettings() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Gap(40),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 35,
              width: 860,
              child: IconButton(
                onPressed: widget.previousPage,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFE9703),
                ),
              ),
            ),
          ),
          Container(
            width: 630,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(40),
                  Text(
                    'Hire Settings',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  Text(
                    'Please provide the following to complete a job post.',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                    ),
                  ),
                  Gap(30),
                  Row(
                    children: [
                      Text(
                        'Hiring timeline for this job',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff202855),
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  ),
                  Gap(10),
                  SizedBox(
                    child: DropdownButtonFormField<String>(
                      decoration: customInputDecoration(),
                      value: selectedTimeline,
                      hint: Text(
                        'Select an option',
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.selectedTimeline = newValue!;
                          selectedTimeline = newValue;
                        });
                        widget.onHiringTimelineChanged(newValue);
                      },
                      items: timelineOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Hiring timeline is required.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: widget.cancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: 'Galano', color: Color(0xffFE9703)),
                          )),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () => _submitJobHireSettings(),
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
          ),
        ],
      ),
    );
  }
}
