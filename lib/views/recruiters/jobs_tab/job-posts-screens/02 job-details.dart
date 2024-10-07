import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobDetails extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  String selectedJobType;
  final ValueChanged<String?> onJobTypeChanged;
  String hrsPerWeek;
  final ValueChanged<String?> onHrsPerWeekChanged;

  JobDetails(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel,
      required this.selectedJobType,
      required this.onJobTypeChanged,
      required this.hrsPerWeek,
      required this.onHrsPerWeekChanged});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  // final _formKey = GlobalKey<FormState>();

  List<String> jobTypes = ['Full-time', 'Part-time', 'Permanent', 'Fixed Term'];
  bool showError = false;

  void _submitJobDetails() {
    // if (_formKey.currentState!.validate()) {
    if (widget.selectedJobType.isEmpty) {
      setState(() {
        showError = true;
      });
    } else {
      widget.nextPage();
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(40),
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
        SizedBox(
          width: 630,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(30),
              const Text(
                'Add Job Details',
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
              const Gap(10),
              const Row(
                children: [
                  Text(
                    'Job type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff202855),
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              ),
              const Gap(10),
              Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                children: jobTypes.map((jobType) {
                  bool isSelected = widget.selectedJobType == jobType;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedJobType = jobType;
                          print('Selected Job Type: ${widget.selectedJobType}');
                        });
                        widget.onJobTypeChanged(widget.selectedJobType);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF21254A)),
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected
                              ? const Color(0xFF21254A)
                              : Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF21254A)),
                            const SizedBox(width: 4),
                            Text(
                              jobType,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF21254A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Gap(10),
              if (showError)
                const Text(
                  'Please select a job type.',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              const Gap(20),
              const Divider(
                color: Colors.grey,
              ),
              const Gap(20),
              const Text(
                'Hours per week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff202855),
                ),
              ),
              Gap(10),
              RadioListTile<String>(
                title: const Text(
                  'More than 30 hrs/week',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202855),
                  ),
                ),
                value: 'More than 30 hrs/week',
                groupValue: widget.hrsPerWeek,
                onChanged: (value) {
                  setState(() {
                    widget.hrsPerWeek = value!;
                  });
                  widget.onHrsPerWeekChanged(value);
                },
              ),
              RadioListTile<String>(
                title: const Text(
                  'Less than 30 hrs/week',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202855),
                  ),
                ),
                value: 'Less than 30 hrs/week',
                groupValue: widget.hrsPerWeek,
                onChanged: (value) {
                  setState(() {
                    widget.hrsPerWeek = value!;
                  });
                  widget.onHrsPerWeekChanged(value);
                },
              ),
              RadioListTile<String>(
                title: const Text(
                  'I’m not sure',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202855),
                  ),
                ),
                value: 'I’m not sure',
                groupValue: widget.hrsPerWeek,
                onChanged: (value) {
                  setState(() {
                    widget.hrsPerWeek = value!;
                  });
                  widget.onHrsPerWeekChanged(value);
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              Gap(10),
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
                    onPressed: () => _submitJobDetails(),
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
    );
  }
}
