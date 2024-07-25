import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class JobPostingSkill extends StatefulWidget {
  JobPostingSkill({super.key});

  @override
  State<JobPostingSkill> createState() => _JobPostingSkillState();
}

class _JobPostingSkillState extends State<JobPostingSkill> {
  final TextEditingController _controller = TextEditingController();

  List<String> _suggestions = [];
  List<String> _clickedSkills = [];
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

  void _updateSuggestions(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _suggestions = _skills
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _suggestions.clear();
      }
    });
  }

  void _deleteClickedItem(int index) {
    setState(() {
      _clickedSkills.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
          SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 35,
                      width: 670,
                      // color: Colors.blue,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFFE9703),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 400,
                      width: 570,
                      // color: Colors.red,
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
                          TextField(
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
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: Stack(
                              children: [
                                // Display clicked items when not typing
                                if (_controller.text.isEmpty)
                                  ListView.builder(
                                    itemCount: _clickedSkills.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xffD1E1FF),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              _clickedSkills[index],
                                              style: const TextStyle(
                                                fontFamily: 'Galano',
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                _deleteClickedItem(index);
                                              },
                                              icon: const Icon(
                                                  Icons.delete_rounded),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xffD1E1FF),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              _suggestions[index],
                                              style: const TextStyle(
                                                fontFamily: 'Galano',
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _clickedSkills
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 50,
                      width: 570,
                      // color: Colors.blue,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Galano',
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
        ],
      ),
    );
  }
}
