import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditJobDetails extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  const EditJobDetails({
    super.key,
    required this.nextPage,
    required this.previousPage,
  });

  @override
  State<EditJobDetails> createState() => _EditJobDetailsState();
}

class _EditJobDetailsState extends State<EditJobDetails> {
  final _formKey = GlobalKey<FormState>();

  // samples
  final TextEditingController jobTitleController =
      TextEditingController(text: 'Architect / Engineer Drafter with...');
  final TextEditingController openingsController =
      TextEditingController(text: '3');
  final TextEditingController locationController =
      TextEditingController(text: 'Brgy. Moreno, Binalonan, Pangasinan');
  final TextEditingController descriptionController = TextEditingController(
      text: 'We urgently need a skilled wedding photograph...');
  final TextEditingController jobTypeController =
      TextEditingController(text: 'Part-time');
  final TextEditingController scheduleController =
      TextEditingController(text: 'Weekends');
  final TextEditingController skillController = TextEditingController(
      text: 'Java, JavaScript, Flutter, Microsoft Office');
  final TextEditingController payController =
      TextEditingController(text: 'From ₱200.00 per hour');
  final TextEditingController supplementalPayController =
      TextEditingController(text: 'Tips, Bonus Pay');
  final TextEditingController requireResumeController =
      TextEditingController(text: 'Yes, require a resume');
  final TextEditingController hiringTimelineController =
      TextEditingController(text: '2-4 weeks');
  final TextEditingController applicationDeadlineController =
      TextEditingController(text: '07/25/2024');
  final TextEditingController updatesController =
      TextEditingController(text: 'huzzle@gmail.com');
  final TextEditingController preScreeningController = TextEditingController(
      text: 'Will you be able to reliably commute or relocate...');

  void _submitJobPost() {
    // if (_formKey.currentState!.validate()) {
    widget.nextPage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Gap(20),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
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
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 630,
              child: const Text(
                'Job Details',
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff202855),
                ),
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 630,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildJobDetailRow('Job title', jobTitleController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Number of openings', openingsController),
                        const Gap(10),
                        _buildJobDetailRow('Location', locationController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Description', descriptionController),
                        const Gap(10),
                        _buildJobDetailRow('Job type', jobTypeController),
                        const Gap(10),
                        _buildJobDetailRow('Schedule', scheduleController),
                        const Gap(10),
                        _buildJobDetailRow('Skill', skillController),
                        const Gap(10),
                        _buildJobDetailRow('Pay', payController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Supplemental Pay', supplementalPayController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Require resume', requireResumeController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Hiring timeline', hiringTimelineController),
                        const Gap(10),
                        _buildJobDetailRow('Application deadline',
                            applicationDeadlineController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Application updates', updatesController),
                        const Gap(10),
                        _buildJobDetailRow(
                            'Customized pre-screening', preScreeningController),
                        const Gap(30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => _submitJobPost(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0038FF),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              child: Row(
                                children: const [
                                  Gap(5),
                                  Text(
                                    'Finish',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Galano',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Gap(10),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff202855),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle edit action
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.blueAccent,
            size: 20,
          ),
        ),
      ],
    );
  }
}
