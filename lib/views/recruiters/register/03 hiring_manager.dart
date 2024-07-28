import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class HiringManagerProfileScreen extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final TextEditingController hiringManFirstnameController;
  final TextEditingController hiringManLastnameController;
  final TextEditingController howHeardAbtUsController;
  final TextEditingController phoneNumberController;

  const HiringManagerProfileScreen({super.key, required this.nextPage, required this.previousPage,
        required this.hiringManFirstnameController,
        required this.hiringManLastnameController,
        required this.howHeardAbtUsController,
        required this.phoneNumberController,
      });

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButtonback(
                    onPressed: widget.previousPage,
                    iconImage: const AssetImage('assets/images/backbutton.png'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                    child: TextFormField(
                      controller: widget.hiringManFirstnameController,
                      validator: (value) {
                        if (value!.isEmpty || value == null) {
                          return "Required";
                        }
                      },
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
                    child: TextFormField(
                      controller: widget.hiringManLastnameController,
                      validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Required";
                      }
                    },
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
                          widget.howHeardAbtUsController.text = newValue ?? '';
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
              TextFormField(
                controller: widget.phoneNumberController,
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Phone number is required";
                      }
                    },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        if (_formKey.currentState!.validate()) widget.nextPage();
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
