import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';

class JobTitlesPage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(String)
      onSaveJobTitles; // Pass selected job titles as a comma-separated string

  JobTitlesPage({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveJobTitles,
  });

  @override
  _JobTitlesPageState createState() => _JobTitlesPageState();
}

class _JobTitlesPageState extends State<JobTitlesPage> {
  List<String> selectedJobTitles = []; // Tracks selected job titles

  void _submitJobTitlesForm() {
    if (selectedJobTitles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one job title.')),
      );
      return;
    }

    // Convert selected job titles to a comma-separated string
    String jobTitlesString = selectedJobTitles.join(', ');
    widget.onSaveJobTitles(jobTitlesString);
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      '3/3',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What kind of job are you looking for?',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'This helps us match you with relevant jobs.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/info.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Select up to 3 specialties.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff929292),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownWithCheckboxes(
                      sections: [
                        DropdownSection(
                          title: 'Accounting & Consulting',
                          items: [
                            'Personal & Professional Coaching',
                            'Accounting & Bookkeeping',
                            'Financial Planning',
                            'Recruiting & Human Resources',
                            'Management Consulting & Analysis',
                            'Other - Accounting & Consulting',
                          ],
                        ),
                        DropdownSection(
                          title: 'Admin Support',
                          items: [
                            'Data Entry & Transcription Services',
                            'Virtual Assistance',
                            'Project Management',
                            'Market Research & Product Reviews',
                          ],
                        ),
                        DropdownSection(
                          title: 'Customer Service',
                          items: [
                            'Community Management & Tagging',
                            'Customer Service & Tech Support',
                          ],
                        ),
                        // Add other categories as needed
                      ],
                      maxSelections: 3, // Limit selections to 3
                      preSelectedItems: selectedJobTitles, // Preselected items
                      onSelectionChanged: (selectedItems) {
                        setState(() {
                          selectedJobTitles = selectedItems;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 130,
                        child: BlueFilledCircleButton(
                          onPressed: _submitJobTitlesForm,
                          text: 'Continue',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}
