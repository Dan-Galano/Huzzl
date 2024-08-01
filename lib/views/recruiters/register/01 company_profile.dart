import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CompanyProfileScreen extends StatefulWidget {
  final VoidCallback nextPage;
  const CompanyProfileScreen({super.key, required this.nextPage});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final List<String> _options = ['1-49', '50-149', '150-249', '250-499'];

  String? _selectedOption;
  final _companyNameController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _CEOFirstNameController = TextEditingController();
  final _CEOLastNameController = TextEditingController();
  final _companyHeadquarterController = TextEditingController();
  final _companyIndustryController = TextEditingController();
  final _companyDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitCompanyProfileForm() {
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
                          onPressed: () => _submitCompanyProfileForm(),
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
                          onPressed: () => _submitCompanyProfileForm(),
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
                    "1/3",
                    style: TextStyle(
                      color: Color(0xffb6b6b6),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Company Profile',
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
                  //This is where the form starts.
                  // Form(child: child),
                  const Text(
                    'Company Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyNameController,
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
                        return "Company Profile is required.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Company Email Address',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyEmailController,
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
                        return "Company Email Address is required.";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "Email Address provided is not valid.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Chief Executive Officer',
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
                          controller: _CEOFirstNameController,
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
                              return "CEO First Name is required.";
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _CEOLastNameController,
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
                              return "CEO Last Name is required.";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Number of Employees',
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
                    'Company\'s headquarter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyHeadquarterController,
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
                        return "Company's HeadQuarter is required.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Company\'s industry',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyIndustryController,
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
                        return "Company's Industry is required.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Company Description',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Introduce your company to people in a few lines.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffb6b6b6),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyDescriptionController,
                    maxLines: 5,
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
                      hintText:
                          'Present your company by communicating your business, your market position, your company culture, etc.',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Company Description is required.";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Company\'s website (optional)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
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
                  // End of form
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
