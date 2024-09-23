import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/custom_input.dart';
import 'package:http/http.dart' as http;

class JobPosts extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback cancel;

  JobPosts({required this.nextPage, required this.cancel});

  @override
  _JobPostsState createState() => _JobPostsState();
}

class _JobPostsState extends State<JobPosts> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescController = TextEditingController();

  String _hiringOption = 'One person';
  String? _selectedValue; // if more than one perso is selected

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  final TextEditingController otherLocationInformation =
      TextEditingController();

  List<dynamic> regions = [];
  List<dynamic> provinces = [];
  List<dynamic> cities = [];
  List<dynamic> barangays = [];

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  void _submitJobPosts() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
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

  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        resetSelections();
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = jsonDecode(response.body);
        resetCityAndBarangaySelections();
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

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

  void resetSelections() {
    selectedProvince = null;
    selectedCity = null;
    selectedBarangay = null;
    cities = [];
    barangays = [];
  }

  void resetCityAndBarangaySelections() {
    selectedCity = null;
    selectedBarangay = null;
    barangays = [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 700,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(25),
                const Text(
                  'Job post',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202855),
                  ),
                ),
                const Text(
                  'Please provide the following to complete a job post.',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 14,
                  ),
                ),
                Gap(20),
                Row(
                  children: [
                    Text(
                      'Job title',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: _jobTitleController,
                  decoration: customInputDecoration(),
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "Job title is required.";
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Number of people to hire for this job',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                RadioListTile<String>(
                  title: const Text(
                    'One person',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'One person',
                  groupValue: _hiringOption,
                  onChanged: (value) {
                    setState(() {
                      _hiringOption = value!;
                      _selectedValue = null; // Reset dropdown value
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'More than one person',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'More than one person',
                  groupValue: _hiringOption,
                  onChanged: (value) {
                    setState(() {
                      _hiringOption = value!;
                      _selectedValue = null; // Reset dropdown value
                    });
                  },
                ),
                Gap(10),
                if (_hiringOption == 'More than one person') ...[
                  DropdownButtonFormField<String>(
                    decoration: customInputDecoration(),
                    value: _selectedValue,
                    hint: const Text("Select an option"),
                    items: <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '10+',
                      'I have an ongoing need to fill this role'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                  ),
                ],
                Gap(10),
                Row(
                  children: [
                    Text(
                      'Where would you like to advertise this job?',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                const Text(
                  'Enter your location',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),

                // Region Dropdown
                buildRegionDropdown(),
                const SizedBox(height: 10),

                // Province Dropdown
                if (selectedRegion != null) buildProvinceDropdown(),
                const SizedBox(height: 10),

                // City Dropdown
                if (selectedProvince != null) buildCityDropdown(),
                const SizedBox(height: 10),

                // Barangay Dropdown
                if (selectedCity != null) buildBarangayDropdown(),
                const SizedBox(height: 10),

                // Other location information field
                if (selectedBarangay != null) buildOtherLocationField(),
                Row(
                  children: [
                    Text(
                      'Job description',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: _jobDescController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: customInputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Job description is required.";
                    } else if (value.length < 30) {
                      return "Job description must be at least 30 characters.";
                    }
                    return null; // Return null if validation passes
                  },
                ),

                Gap(20),
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
                      onPressed: () => _submitJobPosts(),
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
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegionDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: DropdownButtonFormField<String>(
        hint: const Text(
          'Select region',
          style: TextStyle(fontFamily: 'Galano'),
        ),
        decoration: customInputDecoration(),
        value: selectedRegion,
        items: regions.map<DropdownMenuItem<String>>((region) {
          return DropdownMenuItem<String>(
            value: region['name'],
            child: Text(region['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRegion = value;
            resetSelections();
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
    );
  }

  Widget buildProvinceDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: DropdownButtonFormField<String>(
        hint: Text(
          'Select Province',
          style: TextStyle(fontFamily: 'Galano'),
        ),
        decoration: customInputDecoration(),
        value: selectedProvince,
        items: provinces.map<DropdownMenuItem<String>>((province) {
          return DropdownMenuItem<String>(
            value: province['name'],
            child: Text(province['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedProvince = value;
            resetCityAndBarangaySelections();
          });
          if (value != null) {
            final selectedProvinceCode = provinces.firstWhere(
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
    );
  }

  Widget buildCityDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: DropdownButtonFormField<String>(
        hint: Text(
          'Select City/Municipality',
          style: TextStyle(fontFamily: 'Galano'),
        ),
        decoration: customInputDecoration(),
        value: selectedCity,
        items: cities.map<DropdownMenuItem<String>>((city) {
          return DropdownMenuItem<String>(
            value: city['name'],
            child: Text(city['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCity = value;
            selectedBarangay = null;
            barangays = [];
          });
          if (value != null) {
            final selectedCitiesCode = cities.firstWhere(
              (city) => city['name'] == value,
              orElse: () => null,
            )['code'];
            if (selectedCitiesCode != null) {
              fetchBarangays(selectedCitiesCode);
            }
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'City is required.';
          }
          return null;
        },
      ),
    );
  }

  Widget buildBarangayDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: DropdownButtonFormField<String>(
        hint: Text(
          'Select Barangay',
          style: TextStyle(fontFamily: 'Galano'),
        ),
        decoration: customInputDecoration(),
        value: selectedBarangay,
        items: barangays.map<DropdownMenuItem<String>>((barangay) {
          return DropdownMenuItem<String>(
            value: barangay['name'],
            child: Text(barangay['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedBarangay = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Barangay is required.';
          }
          return null;
        },
      ),
    );
  }

  Widget buildOtherLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('If the location is not listed above, please enter it here:'),
        TextFormField(
          controller: otherLocationInformation,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
