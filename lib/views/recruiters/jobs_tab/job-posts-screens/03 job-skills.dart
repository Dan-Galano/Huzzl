import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';

class JobSkills extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  final List<String> selectedSkills;
  final List<String> responsibilities;

  const JobSkills({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.cancel,
    required this.selectedSkills,
    required this.responsibilities,
  });

  @override
  State<JobSkills> createState() => _JobSkillsState();
}

class _JobSkillsState extends State<JobSkills> {
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

  void _addResponsibility() {
    final questionText = _responsibilitiesController.text.trim();
    if (questionText.isNotEmpty) {
      setState(() {
        widget.responsibilities.add(questionText);
        _responsibilitiesController.clear();
      });
    }
  }

  void _deleteResponsibilityClickedItem(int index) {
    setState(() {
      widget.responsibilities.removeAt(index);
    });
  }

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
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(40),
          Container(
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.2, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Skills',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'What are the skills required for this job? Provide at least two (2).',
                    style: TextStyle(),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Skill ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff202855),
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Responsibilities ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff202855),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 30),
                        onPressed: _addResponsibility,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _responsibilitiesController,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            hintText: 'Add responsibility...',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffD1E1FF),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffD1E1FF),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (widget.responsibilities.isEmpty) {
                              return "Add at least one responsibility";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Responsibilities list
                  if (widget.responsibilities.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.responsibilities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.responsibilities[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_rounded),
                            onPressed: () =>
                                _deleteResponsibilityClickedItem(index),
                          ),
                        );
                      },
                    ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xffFE9703)),
                        ),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: _submitJobSkills,
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
          ),
        ],
      ),
    );
  }
}
