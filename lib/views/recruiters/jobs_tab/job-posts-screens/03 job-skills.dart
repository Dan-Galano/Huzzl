import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobSkills extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  final List<String> selectedSkills;

  const JobSkills(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel,
      required this.selectedSkills});

  @override
  State<JobSkills> createState() => _JobSkillsState();
}

class _JobSkillsState extends State<JobSkills> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  List<String> _suggestions = [];
  final List<String> _skills = [
    'Communication Skills',
    'Critical Thinking',
    'Project Management',
    'Coding/Programming',
    'Data Analysis',
    'Time Management',
    'Creative Thinking',
    'Public Speaking',
    'Problem Solving',
    'Team Collaboration',
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(40),
        Center(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 35,
            width: 860,
            // color: Colors.blue,
            child: IconButton(
              onPressed: widget.previousPage,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFE9703),
              ),
            ),
          ),
        ),
        Gap(40),
        Center(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 400,
            width: 630,
            // color: Colors.red,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Skills',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'What are the skills required for this job? Provide at least two (2).',
                    style: TextStyle(
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Skill ',
                            style: TextStyle(
                              fontFamily: 'Galano',
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontFamily: 'Galano',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _controller,
                    onChanged: _updateSuggestions,
                    style: const TextStyle(
                      fontFamily: 'Galano',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Flutter',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
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
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffD1E1FF),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (widget.selectedSkills.isEmpty) {
                        return "Skill Required";
                      } else if (widget.selectedSkills.length < 2) {
                        return "Please select at least 2 skills";
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Stack(
                      children: [
                        // Display clicked items when not typing
                        if (_controller.text.isEmpty)
                          ListView.builder(
                            itemCount: widget.selectedSkills.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD1E1FF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      widget.selectedSkills[index],
                                      style: const TextStyle(
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        _deleteClickedItem(index);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        // Display suggestions when typing
                        if (_controller.text.isNotEmpty)
                          ListView.builder(
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD1E1FF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      _suggestions[index],
                                      style: const TextStyle(
                                        fontFamily: 'Galano',
                                      ),
                                    ),
                                    onTap: () {
                                      // bool isSelected = widget.selectedSkills
                                      //     .contains(_suggestions[index]);
                                      setState(() {
                                        widget.selectedSkills
                                            .add(_suggestions[index]);
                                        _controller.clear();
                                        _suggestions.clear();
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
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
                        onPressed: () => _submitJobSkills(),
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
        ),
      ],
    );
  }
}
