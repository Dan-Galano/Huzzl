import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CompanyProfileRecruiter extends StatefulWidget {
  UserCredential userCredential;
  CompanyProfileRecruiter({
    required this.userCredential,
    super.key,
  });

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
  var _companyWebsite = TextEditingController();
  var _socialMediaLinks = TextEditingController();

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  final otherLocationInformation = TextEditingController();

  List regions = [];
  List provinces = [];
  List cities = [];
  List barangays = [];

  //List of documents for business verification
  List<String> businessDocs = <String>[
    "Article of incorporation",
    "Business licence",
    "Company liability insurance",
    "Office utility bill",
    "Lease of franchise agreement",
    "Tax permit",
    "Staffing agency employment letter or payslip",
  ];

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

  //Business Docs File
  List<String> fileNames = []; // List to hold file names

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        // Add the selected file names to the list
        fileNames.addAll(result.files.map((file) => file.name));
      });
    }
  }

  void _onDropFile(PlatformFile file) {
    setState(() {
      // Add the dropped file name to the list
      fileNames.add(file.name);
    });
  }

  //SubmitForm
  void submitCompanyProfileForm() async {
    if (_formkey.currentState!.validate()) {
      try {
        // Store data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userCredential.user!.uid)
            .collection("company_information")
            .add({
          'uid': widget.userCredential.user!.uid,
          'companyName': _companyName.text,
          'ceoFirstName': _CEOFirstName.text,
          'ceoLastName': _CEOLastName.text,
          'region': selectedRegion ?? 'not specified',
          'province': selectedProvince ?? 'not specified',
          'city': selectedCity ?? 'not specified',
          'barangay': selectedBarangay ?? 'not specified',
          'locationOtherInformation': otherLocationInformation.text,
          'companySize': _selectedSizeOfCompany,
          'companyDescription': _description.text,
          'companyWebsite':
              _companyWebsite.text.isNotEmpty ? _companyWebsite.text : 'none',
        });

        // Navigate to RecruiterHomeScreen after successful submission
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const RecruiterHomeScreen(),
          ),
        );
        print("User credential: ${widget.userCredential.user!.uid}");
      } catch (e) {
        // Handle any errors
        print("Failed to submit company profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit company profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerPadding = MediaQuery.of(context).size.width * 0.2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const NavBarLoginRegister(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: containerPadding),
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
                            List<String> descriptionWords = value.split(' ');
                            if (descriptionWords.length < 100) {
                              return "Compay description should contain at least 100 words";
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
                          controller: _socialMediaLinks,
                          style: const TextStyle(
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
                        const SizedBox(height: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Social Media Links (optional)",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Enter your company’s social media links, separating each with a comma. (Facebook link, Tiktok link)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _companyWebsite,
                          style: const TextStyle(
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
                        const SizedBox(height: 20),
                        const Text(
                          "Verify with document helps us confirm you work for a real business",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Some acceptable documents include:",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: businessDocs
                              .map(
                                (item) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        DragTarget<PlatformFile>(
                          onAccept: (file) => _onDropFile(
                              file), // Expecting a single PlatformFile
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              height: 150,
                              width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent,
                                    style: BorderStyle.solid,
                                    width: 2),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file,
                                      size: 40, color: Colors.blueAccent),
                                  Text("Drag and drop here, or"),
                                  GestureDetector(
                                    onTap: _pickFile,
                                    child: Text(
                                      "Select a file",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // Display selected or dropped files
                                  if (fileNames.isNotEmpty)
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: fileNames.length,
                                        itemBuilder: (context, index) {
                                          return Text(fileNames[index],
                                              style: TextStyle(fontSize: 16));
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
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
