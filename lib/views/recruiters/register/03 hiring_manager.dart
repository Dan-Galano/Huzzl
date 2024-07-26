import 'package:flutter/material.dart';

class HiringManagerProfileScreen extends StatefulWidget {
  const HiringManagerProfileScreen({super.key});

  @override
  State<HiringManagerProfileScreen> createState() =>
      _HiringManagerProfileScreenState();
}

class _HiringManagerProfileScreenState
    extends State<HiringManagerProfileScreen> {
  final List<String> _options = [
    'TV',
    'Mail',
    'Newspaper',
    'Word-of-mouth',
    'Search engine (ex. Google, Bing, Yahoo)',
    'Billboard',
    'Streaming audio (ex. Spotify, Pandora)',
    'Social media',
    'Radio',
    'Podcast',
    'Other',
  ];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 670,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //back button pa here
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "2/3",
                    style: TextStyle(
                      color: Color(0xffb6b6b6),
                      fontFamily: 'Galano',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hiring Manager Profile',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please provide the following to complete company profile.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hiring Manager Name',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        hintText: 'First name',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB6B6B6),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1E1FF),
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Last name',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB6B6B6),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How you heard about us?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedOption,
                      hint: const Text('Select an option'),
                      items: _options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'For account management communication and verification. Not visible to job seekers.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffb6b6b6),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1E1FF),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1E1FF),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1E1FF),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        //onpressed
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserOptionScreen(),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0038FF),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text('Next',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
