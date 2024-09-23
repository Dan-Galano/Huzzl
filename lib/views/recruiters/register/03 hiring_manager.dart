import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
  final _hiringManagerFirstNameController = TextEditingController();
  final _hiringManagerLastNameController = TextEditingController();
  final _hiringManagerPhoneNumberController = TextEditingController();

  void _submitHiringManagerForm() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double formPadding;

        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          formPadding = 350;
        } else if (sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet) {
          formPadding = 100;
        } else {
          formPadding = 20;
        }

        bool haveABackButton =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? true
                : false;

        var buttonResponsiveness =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () => _submitHiringManagerForm(),
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
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _submitHiringManagerForm(),
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
                  );

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: formPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  haveABackButton
                      ? IconButtonback(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          iconImage:
                              const AssetImage('assets/images/backbutton.png'),
                        )
                      : const SizedBox(height: 0),
                  const SizedBox(height: 30),
                  const Text(
                    "2/3",
                    style: TextStyle(
                      color: Color(0xffb6b6b6),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Hiring Manager Profile',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Please provide the following to complete company profile.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hiring Manager Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hiringManagerFirstNameController,
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
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "Hiring Manager first name is required.";
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _hiringManagerLastNameController,
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
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "Hiring Manager last name is required.";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'How you heard about us?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
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
                  const Text(
                    'Your Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'For account management communication and verification. Not visible to job seekers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffb6b6b6),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _hiringManagerPhoneNumberController,
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
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Hiring Manager phone number is required.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  buttonResponsiveness,
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
