import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobDetails extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  const JobDetails(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  // final _formKey = GlobalKey<FormState>();

  List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Permanent',
    'Fresh Graduate'
  ];
  String selectedJobType = 'Full-time';

  String _selectedSched = 'More than 30 hrs/week';

  void _submitJobDetails() {
    // if (_formKey.currentState!.validate()) {
    widget.nextPage();
    // }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(30),
                Text(
                  'Add Job Details',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 30,
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
                Gap(10),
                Row(
                  children: [
                    Text(
                      'Job type',
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
                Wrap(
                  spacing: 12.0, // Spacing between chips
                  runSpacing: 8.0, // Spacing for wrapping
                  children: jobTypes.map((jobType) {
                    bool isSelected = selectedJobType == jobType;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedJobType = isSelected ? '' : jobType;
                          print('Selected Job Type: $selectedJobType');
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF21254A)),
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected ? Color(0xFF21254A) : Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xFF21254A)),
                            Gap(4),
                            Text(
                              jobType,
                              style: TextStyle(
                                fontFamily: 'Galano',
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xFF21254A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Gap(20),
                Divider(
                  color: Colors.grey,
                ),
                Gap(20),
                Text(
                  'Schedule',
                  style: TextStyle(
                    fontFamily: 'Galano',
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
                      fontFamily: 'Galano',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'More than 30 hrs/week',
                  groupValue: _selectedSched,
                  onChanged: (value) {
                    setState(() {
                      _selectedSched = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'Less than 30 hrs/week',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'Less than 30 hrs/week',
                  groupValue: _selectedSched,
                  onChanged: (value) {
                    setState(() {
                      _selectedSched = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'I’m not sure',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'I’m not sure',
                  groupValue: _selectedSched,
                  onChanged: (value) {
                    setState(() {
                      _selectedSched = value!;
                    });
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
                          style: TextStyle(
                              fontFamily: 'Galano', color: Color(0xffFE9703)),
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
    );
  }
}
