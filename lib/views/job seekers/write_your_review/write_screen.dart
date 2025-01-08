import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_view.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/congrats.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/tell_us_about_you.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// DITO YUNG COMPANY REVIEW AT PROFILE GUYS
// void main() {
//   runApp(
//       MaterialApp(debugShowCheckedModeBanner: false, home: WriteReviewPage()));
// }
class WriteReviewPage extends StatefulWidget {
  final String recruiterId;
  const WriteReviewPage({super.key, required this.recruiterId});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobLocationController = TextEditingController();

  int _rating = 0;

  void _onStarTapped(int index) {
    setState(() {
      _rating = (index + 1).toInt(); // Ensure rating is always an integer
    });
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
    }
  }

  Future<void> _submitReview() async {
    print("hiiii");
    String summary = _summaryController.text.isNotEmpty
        ? _summaryController.text
        : "No summary provided";
    String jobTitle = jobTitleController.text.isNotEmpty
        ? jobTitleController.text
        : "No job title provided";
    String jobLocation = jobLocationController.text.isNotEmpty
        ? jobLocationController.text
        : "No job location provided";
    String description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : "No description provided";
    String startDate = startDateController.text.isNotEmpty
        ? startDateController.text
        : "No start date selected";
    String endDate = endDateController.text.isNotEmpty
        ? endDateController.text
        : "No end date selected";
    print("""
      Review Summary: $summary
      Job Title: $jobTitle
      Job Location: $jobLocation
      Description: $description
      Start Date: $startDate
      End Date: $endDate
      Rating: $_rating
    """);
    if (_formKey.currentState?.validate() == true && _rating > 0) {
      // Get values from the controllers or provide fallbacks
      print("Form is valid");
      try {
        // Ensure both start and end dates are provided
        if (startDateController.text.isNotEmpty &&
            endDateController.text.isNotEmpty) {
          DateTime startDateParsed = DateFormat('dd/MM/yyyy').parse(startDate);
          DateTime endDateParsed = DateFormat('dd/MM/yyyy').parse(endDate);

          final provider =
              Provider.of<CompanyProfileProvider>(context, listen: false);

          // Ensure none of the values are null before calling addNewReview
          await provider.addNewReview(
            userId: widget.recruiterId,
            reviewBranch: jobLocation.isNotEmpty ? jobLocation : "",
            reviewDescription: description.isNotEmpty ? description : "",
            reviewJobDate: endDateParsed,
            reviewJobDateStart: startDateParsed,
            reviewPosition: jobTitle.isNotEmpty ? jobTitle : "",
            reviewStars: _rating,
            reviewSummary: summary,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Review submitted successfully!")),
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                ReviewCongratulationPage(recruiterId: widget.recruiterId),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please select both start and end dates.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit review: $e")),
        );
      }
    } else {
      print("Form is invalid");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and give a rating!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 350.0, vertical: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                          "Job Title *",
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
                          "Job Location *",
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
                                    onTap: () => _selectDate(
                                        context, startDateController),
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
                      ],
                    ),
                    const Text(
                      "Write your review",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your anonymous feedback will help fellow jobseekers",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Galano',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Overall Rating *",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () => _onStarTapped(index),
                          icon: Icon(
                            Icons.star,
                            color: index < _rating
                                ? const Color(0xFFF39C12)
                                : Colors.grey.shade300,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Poor",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Galano',
                              color: Colors.grey),
                        ),
                        Text(
                          "Excellent",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Galano',
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Review Summary *",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _summaryController,
                      decoration: InputDecoration(
                        hintText: "Enter a summary of your review",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xffD1E1FF)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a summary.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Your Review *",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202855),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Give us your opinion about:\n"
                      "- a typical day at work,\n"
                      "- what you believe you learned,\n"
                      "- management,\n"
                      "- workplace culture,\n"
                      "- the hardest part of the job,\n"
                      "- the most enjoyable part of the job\n"
                      "(150 characters minimum)",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Galano',
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: "Write your review here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xffD1E1FF)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please write your review.';
                        }
                        if (value.length < 150) {
                          return 'Review must be at least 150 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () => _submitReview(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0038FF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Color(0xff0038FF)),
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
                    const SizedBox(height: 24),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
