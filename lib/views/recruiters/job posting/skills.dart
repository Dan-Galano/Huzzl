import 'package:flutter/material.dart';

class JobPostingSkill extends StatelessWidget {
  const JobPostingSkill({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 10,
                  width: 630,
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
              const SizedBox(height: 20),
              Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 300,
                  width: 530,
                  // color: Colors.red,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Skills',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'What are the skills required for this job? Provide at least two (2).',
                        style: TextStyle(
                          fontFamily: 'Galano',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
