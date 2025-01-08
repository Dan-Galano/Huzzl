import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/congrats.dart';
import 'package:intl/intl.dart';

class TellUsPage extends StatefulWidget {
  const TellUsPage({super.key});

  @override
  _TellUsPageState createState() => _TellUsPageState();
}

class _TellUsPageState extends State<TellUsPage> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobLocationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    jobTitleController.dispose();
    jobLocationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    } else {
      // Optionally show an error or warning if date selection is mandatory.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 350.0,
                vertical: 120.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tell us about you",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Job Title at Huzzl *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: jobTitleController,
                      decoration: InputDecoration(
                        hintText: "Enter your job title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Job title is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Job Location at Huzzl *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: jobLocationController,
                      decoration: InputDecoration(
                        hintText: "Enter your job location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Job location is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Start Date *",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff202855),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: startDateController,
                                readOnly: true,
                                onTap: () =>
                                    _selectDate(context, startDateController),
                                decoration: InputDecoration(
                                  hintText: "Select Date",
                                  suffixIcon:
                                      const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Start date is required";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "End Date *",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff202855),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: endDateController,
                                readOnly: true,
                                onTap: () =>
                                    _selectDate(context, endDateController),
                                decoration: InputDecoration(
                                  hintText: "Select Date",
                                  suffixIcon:
                                      const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "End date is required";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ReviewCongratulationPage(
                              //       goBack: () {
                              //         Navigator.pop(context);
                              //       },
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0038FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  color: Color(0xff0038FF)),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 240,
            top: 100,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
