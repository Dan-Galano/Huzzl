import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:http/http.dart' as http;

class CompanyProfileRecruiter extends StatefulWidget {
  CompanyProfileRecruiter({super.key});

  @override
  State<CompanyProfileRecruiter> createState() =>
      _CompanyProfileRecruiterState();
}

class _CompanyProfileRecruiterState extends State<CompanyProfileRecruiter> {
  final _formkey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _CEOFirstName = TextEditingController();
  final _CEOLastName = TextEditingController();
  final _description = TextEditingController();
  final _companyWebsite = TextEditingController();

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  final otherLocationInformation = TextEditingController();

  List regions = [];
  List provinces = [];
  List cities = [];
  List barangays = [];

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      setState(() {
        regions = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Fetch provinces from the API
  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        selectedProvince = null; // Reset selected province
        cities = [];
        selectedCity = null; // Reset selected city
        barangays = []; // Clear barangays
        selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  // Fetch cities by province code
  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = jsonDecode(response.body);
        selectedCity = null; // Reset selected city
        selectedBarangay = null; // Reset selected barangay
        barangays = []; // Clear barangay list
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Fetch barangays by city/municipality code
  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
    if (response.statusCode == 200) {
      setState(() {
        barangays = jsonDecode(response.body);
        selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  //Industry
  String? _selectedIndustry;
  final List<String> _industries = [
    'Aerospace & Defense',
    'Agriculture',
    'Arts, Entertainment & Recreation',
    'Automotive',
    'Education',
    'Energy, Mining & Utilities',
    'Fashion & Beauty',
    'Finance & Accounting',
    'Food & Beverage',
    'Government & Public Administration',
    'Healthcare',
    'Hotels & Travel Accommodation',
    'Human Resources & Staffing',
    'Information Technology',
    'Insurance',
    'Legal',
    'Management & Consulting',
    'Manufacturing',
    'Media & Entertainment',
    'Military & Defense',
    'Mining',
    'Real Estate',
    'Retail & Consumer Goods',
    'Sales & Marketing',
    'Science & Medicine',
    'Sports & Medicine',
    'Supply Chain',
    'Transportation & Warehousing',
    'Travel & Hospitality',
  ];

  //Size
  String? _selectedSizeOfCompany;
  final List<String> sizeOfCompany = [
    "It's just me",
    '2 to 9 employees',
    '10 to 99 employees',
    '100 to 1,000 employees',
    'more than 1,000 employees',
  ];

  //SubmitForm

  void submitCompanyProfileForm() {
    if (_formkey.currentState!.validate()) {
      print(
          "Data: ${_companyName.text}, ${_CEOFirstName.text} ${_CEOLastName.text}, $selectedRegion $selectedProvince $selectedCity $selectedBarangay ${otherLocationInformation.text}, $_selectedSizeOfCompany, $_selectedSizeOfCompany, ${_description.text}, ${_companyWebsite.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const NavBarLoginRegister(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 550),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Company Profile",
                                  style: TextStyle(
                                    fontFamily: "Galano",
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Please provide the following to complete company profile.",
                                  style: TextStyle(
                                    fontFamily: "Galano",
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //Company Name
                        const Text(
                          "Company Name",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: _companyName,
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
                              return "Company name is required.";
                            }
                            return null;
                          },
                        ),
                        //CEO Name
                        const SizedBox(height: 20),
                        const Text(
                          "Chief Executive Officer",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _CEOFirstName,
                                    decoration: InputDecoration(
                                      hintText: "First Name",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                        return "CEO first name is required.";
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _CEOLastName,
                                    decoration: InputDecoration(
                                      hintText: "Last Name",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                        return "CEO last name is required.";
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //Headquaters
                        const SizedBox(height: 20),
                        const Text(
                          "Headquaters",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration:
                              InputDecoration(labelText: 'Select Region'),
                          value: selectedRegion,
                          items:
                              regions.map<DropdownMenuItem<String>>((region) {
                            return DropdownMenuItem<String>(
                              value: region['name'],
                              child: Text(region['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegion = value;
                              provinces = [];
                              selectedProvince = null;
                              cities = [];
                              selectedCity = null;
                              barangays = [];
                              selectedBarangay = null;
                            });

                            if (value != null) {
                              final selectedRegionCode = regions.firstWhere(
                                (region) => region['name'] == value,
                                orElse: () => null,
                              )['code'];

                              if (selectedRegionCode != null) {
                                fetchProvinces(selectedRegionCode);
                              }
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Region is required.';
                            }
                            return null;
                          },
                        ),

                        // Province Dropdown
                        if (selectedRegion != null)
                          Column(
                            children: [
                              SizedBox(height: 16.0),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'Select Province'),
                                value: selectedProvince,
                                items: provinces
                                    .map<DropdownMenuItem<String>>((province) {
                                  return DropdownMenuItem<String>(
                                    value: province['name'],
                                    child: Text(province['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedProvince = value;
                                    cities = [];
                                    selectedCity = null;
                                    barangays = [];
                                    selectedBarangay = null;
                                  });
                                  if (value != null) {
                                    final selectedProvinceCode =
                                        provinces.firstWhere(
                                      (province) => province['name'] == value,
                                      orElse: () => null,
                                    )['code'];

                                    if (selectedProvinceCode != null) {
                                      fetchCities(selectedProvinceCode);
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Province is required.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                        // City Dropdown
                        if (selectedProvince != null)
                          Column(
                            children: [
                              SizedBox(height: 16.0),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'Select City/Municipality'),
                                value: selectedCity,
                                items: cities
                                    .map<DropdownMenuItem<String>>((city) {
                                  return DropdownMenuItem<String>(
                                    value: city['name'],
                                    child: Text(city['name']),
                                  );
                                }).toList(),
                                onChanged: selectedProvince != null
                                    ? (value) {
                                        setState(() {
                                          selectedCity = value;
                                          barangays = [];
                                          selectedBarangay = null;
                                        });
                                        if (value != null) {
                                          final selectedCitiesCode =
                                              cities.firstWhere(
                                            (city) => city['name'] == value,
                                            orElse: () => null,
                                          )['code'];
                                          if (selectedCitiesCode != null) {
                                            fetchBarangays(selectedCitiesCode);
                                          }
                                        }
                                      }
                                    : null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'City is required.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                        // Barangay Dropdown
                        if (selectedCity != null)
                          Column(
                            children: [
                              SizedBox(height: 16.0),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'Select Barangay'),
                                value: selectedBarangay,
                                items: barangays
                                    .map<DropdownMenuItem<String>>((barangay) {
                                  return DropdownMenuItem<String>(
                                    value: barangay['name'],
                                    child: Text(barangay['name']),
                                  );
                                }).toList(),
                                onChanged: selectedCity != null
                                    ? (value) {
                                        setState(() {
                                          selectedBarangay = value;
                                        });
                                      }
                                    : null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Barangay is required.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                        //Other information
                        if (selectedBarangay != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: otherLocationInformation,
                                decoration: InputDecoration(
                                  hintText: "Street Name, Building, House No.",
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
                                    return "This field is required.";
                                  }
                                },
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),
                        const Text(
                          "Industry",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              hint: const Text('Select an industry'),
                              value: _selectedIndustry,
                              items: _industries.map<DropdownMenuItem<String>>(
                                  (String industry) {
                                return DropdownMenuItem<String>(
                                  value: industry,
                                  child: Text(industry),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedIndustry = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Industry is required.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              hint: const Text('Select size'),
                              value: _selectedSizeOfCompany,
                              items: sizeOfCompany
                                  .map<DropdownMenuItem<String>>((String size) {
                                return DropdownMenuItem<String>(
                                  value: size,
                                  child: Text(size),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSizeOfCompany = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Size is required.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff373030),
                                    fontFamily: 'Galano',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Introduce your company to people in few lines.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff373030),
                                    fontFamily: 'Galano',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _description,
                          maxLines: 7,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Galano",
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "Present your company by communicating your business, your market position, your company culture, etc.",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: "Galano",
                            ),
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
                              return "Company description is required.";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Company's website (optional)",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: _companyWebsite,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Galano",
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: "Galano",
                            ),
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
                          // validator: (value) {
                          //   if (value!.isEmpty || value == null) {
                          //     return "Last name is required.";
                          //   }
                          // },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlueFilledCircleButton(
                              onPressed: () {
                                submitCompanyProfileForm();
                              },
                              text: "Submit",
                              width: 150,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
