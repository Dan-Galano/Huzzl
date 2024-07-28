import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

class CompanyProfileScreen extends StatefulWidget {
  final VoidCallback nextPage;

  final TextEditingController companyNameController;
  final TextEditingController companyEmailController;
  final TextEditingController ceoFirstnameController;
  final TextEditingController ceoLastnameController;
  final TextEditingController numEmployeesController;
  final TextEditingController companyHeadquarterController;
  final TextEditingController companyIndustryController;
  final TextEditingController companyDescriptionController;
  final TextEditingController companyWebsiteController;

  const CompanyProfileScreen({super.key, required this.nextPage,
    required this.companyNameController,
    required this.companyEmailController,
    required this.ceoFirstnameController,
    required this.ceoLastnameController,
    required this.numEmployeesController,
    required this.companyHeadquarterController,
    required this.companyIndustryController,
    required this.companyDescriptionController,
    required this.companyWebsiteController,
  });

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final List<String> _options = ['1-49', '50-149', '150-249', '250-499'];

  String? _selectedOption;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 400),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButtonback(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconImage: const AssetImage('assets/images/backbutton.png'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "1/3",
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
                    'Company Profile',
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
                  'Company Name',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.companyNameController,
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
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Company name is required";
                      }
                    },
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Company Email Address',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.companyEmailController,
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
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Company email is required";
                      }
                      if (!EmailValidator.validate(value)) {
                      return 'Invalid email';
                    }
                    },
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chief Executive Officer',
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
                      controller: widget.ceoFirstnameController,
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
                      controller: widget.ceoLastnameController,
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
                  'Number of Employees',
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
                          widget.numEmployeesController.text = newValue ?? '';
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
                  'Company\'s headquearter',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.companyHeadquarterController,
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Required";
                      }
                    },
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Company\'s industry',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.companyIndustryController,
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Required";
                      }
                    },
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Company Description',
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
                  'Introduce your company to people in a few lines.',
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
                controller: widget.companyDescriptionController,
                validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Required";
                      }
                    },
                maxLines: 5,
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
                  hintText:
                      'Present your company by communicating your business, your market position, your company culture, etc.',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Company\'s website (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.companyWebsiteController,
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
