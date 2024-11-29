import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResumePageManual3 extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final List<String> selectedSkills;
  const ResumePageManual3({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.selectedSkills,
  });

  @override
  _ResumePageManual3State createState() => _ResumePageManual3State();
}

class _ResumePageManual3State extends State<ResumePageManual3> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var pnumberController = TextEditingController();
  var emailController = TextEditingController();
  void _submitResumeOption() {
    widget.nextPage();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _responsibilitiesController =
      TextEditingController();

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  List<String> _suggestions = [];
  final List<String> _skills = [
    'Adaptability',
    'Analytical Thinking',
    'Attention to Detail',
    'Bilingual Communication',
    'Branding Skills',
    'Business Writing',
    'Change Management',
    'Collaboration',
    'Communication Skills',
    'Conflict Resolution',
    'Creative Thinking',
    'Critical Thinking',
    'Customer Service',
    'Data Analysis',
    'Decision Making',
    'Emotional Intelligence',
    'Financial Literacy',
    'Flexibility',
    'Interpersonal Skills',
    'Leadership',
    'Motivational Skills',
    'Negotiation',
    'Networking',
    'Open-Mindedness',
    'Organization',
    'Personal Branding',
    'Problem Solving',
    'Project Management',
    'Public Speaking',
    'Research Skills',
    'Resilience',
    'Sales Skills',
    'Strategic Planning',
    'Stress Management',
    'Team Collaboration',
    'Technical Proficiency',
    'Time Management',
    'Training and Mentoring',
    'Trend Analysis',
    'Vendor Management',
    'Written Communication',
  ];

 

  void _submitJobSkills() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  void _updateSuggestions(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _suggestions = _skills
            .where((item) =>
                item.toLowerCase().contains(query.toLowerCase()) &&
                !widget.selectedSkills
                    .contains(item)) // Exclude selected skills
            .toList();
      } else {
        _suggestions.clear();
      }
    });
  }

  void _deleteClickedItem(int index) {
    setState(() {
      widget.selectedSkills.removeAt(index);
    });
  }

  List<String> getSuggestions(String query) {
    List<String> matches = _skills
        .where((item) =>
            item.toLowerCase().contains(query.toLowerCase()) &&
            !widget.selectedSkills.contains(item)) // Exclude selected skills
        .toList();
    return matches;
  }

  Widget buildSearchDropdown() {
    return GestureDetector(
      onTap: () {
        suggestionBoxController.close();
      },
      child: DropDownSearchFormField<String>(
        // Change type to Applicant
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          decoration: customHintTextInputDecoration('Type a skill...'),
        ),
        suggestionsCallback: (pattern) async {
          return await getSuggestions(pattern); // Now returns List<Applicant>
        },
        itemBuilder: (context, applicant) {
          // Change to accept Applicant
          return ListTile(
            onTap: () {
              setState(() {
                widget.selectedSkills.add(applicant);
                _controller.clear();
                _suggestions.clear();
                suggestionBoxController.close();
              });
            },
            title: Text(applicant), // Show applicant's name
          );
        },
        itemSeparatorBuilder: (context, index) {
          return const Divider();
        },
        onSuggestionSelected: _updateSuggestions,
        suggestionsBoxController: suggestionBoxController,
        validator: (value) {
          if (widget.selectedSkills.isEmpty) {
            return "Skill Required";
          } else if (widget.selectedSkills.length < 2) {
            return "Please select at least 2 skills";
          }
          return null; // Validation success
        },

        displayAllSuggestionWhenTap: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 400.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 300,
                          animateFromLastPercent: true,
                          barRadius: Radius.circular(20),
                          lineHeight: 10,
                          percent: 3 / 5,
                          backgroundColor: Colors.orange.withOpacity(0.4),
                          progressColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'A list of your key abilities and proficiencies applicable across various roles and industries.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Gap(40),
                  buildSearchDropdown(),
                  const SizedBox(height: 10),
                  // Display skills
                  if (widget.selectedSkills.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.selectedSkills
                          .map(
                            (skill) => Chip(
                              label: Text(skill),
                              onDeleted: () => _deleteClickedItem(
                                  widget.selectedSkills.indexOf(skill)),
                            ),
                          )
                          .toList(),
                    ),
                  // const SizedBox(height: 10),
                  // Display suggestions
                  if (_controller.text.isNotEmpty)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffD1E1FF),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_suggestions[index]),
                            onTap: () {
                              setState(() {
                                widget.selectedSkills.add(_suggestions[index]);
                                _controller.clear();
                                _suggestions.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Skip",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          widget.nextPage();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 130,
                          child: BlueFilledCircleButton(
                            onPressed: _submitResumeOption,
                            text: 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child:  IconButton(
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
