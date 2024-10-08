import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:http/http.dart' as http;

class ContactInformationScreen extends StatefulWidget {
  const ContactInformationScreen({super.key});

  @override
  State<ContactInformationScreen> createState() =>
      _ContactInformationScreenState();
}

class _ContactInformationScreenState extends State<ContactInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEmailEnabled = false;

  var otherLocationController = TextEditingController();
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  List<dynamic> regions = [];
  List<dynamic> provinces = [];
  List<dynamic> cities = [];
  List<dynamic> barangays = [];

  // void toggleEmail() {
  //   setState(() {
  //     isEmailEnabled = !isEmailEnabled;
  //   });
  // }

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

  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        // resetSelections();
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
        // resetCityAndBarangaySelections();
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
        // selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(40),
            Center(
              child: Container(
                alignment: Alignment.centerLeft,
                width: 860,
                child: IconButtonback(
                  onPressed: () {
                    JobseekerMainScreenState? mainScreenState = context
                        .findAncestorStateOfType<JobseekerMainScreenState>();
                    mainScreenState?.switchScreen(4);
                  },
                  iconImage: const AssetImage('assets/images/backbutton.png'),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 670,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'First name',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffFF3D3D),
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: _emailController,
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

                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Last name',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffFF3D3D),
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: _emailController,
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
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: _phoneController,
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
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/phflag.png',
                                  width: 30,
                                ),
                                SizedBox(width: 8),
                                Text('+63', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 0, // You can adjust these values
                            minHeight: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: emailController,
                        initialValue: 'eleanor.pena@gmail.com',
                        enabled: isEmailEnabled,
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
                          // suffixIcon: GestureDetector(
                          //   onTap: () {
                          //     // Toggle email editing
                          //     print('click');
                          //     toggleEmail();
                          //   },
                          //   child: Padding(
                          //     padding: EdgeInsets.only(top: 10),
                          //     child: Text(
                          //       isEmailEnabled
                          //           ? 'Done'
                          //           : 'Edit', // Change the text based on state
                          //       style: TextStyle(color: Colors.blue),
                          //     ),
                          //   ),
                          // ),
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty || value == null) {
                        //     return "Email Address is required.";
                        //   }
                        //   if (!EmailValidator.validate(value)) {
                        //     return "Please provide a valid email address.";
                        //   }
                        // },
                      ),
                      Gap(10),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Gap(10),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0038FF),
                              // padding: EdgeInsets.all(20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                          child: const Text('Save',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                      ),
                      Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegionDropdown() {
    return SizedBox(
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
        onChanged: (String? newValue) {
          setState(() {
            selectedRegion = newValue;
            // resetSelections();
          });
          if (newValue != null) {
            final selectedRegionCode = regions.firstWhere(
              (region) => region['name'] == newValue,
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
      // width: MediaQuery.of(context).size.width * 0.25,
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
        onChanged: (String? newValue) {
          setState(() {
            selectedProvince = newValue;
            // resetCityAndBarangaySelections();
          });
          if (newValue != null) {
            final selectedProvinceCode = provinces.firstWhere(
              (province) => province['name'] == newValue,
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
      // width: MediaQuery.of(context).size.width * 0.25,
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
        onChanged: (String? newValue) {
          setState(() {
            selectedCity = newValue;
            // selectedBarangay = null;
            // barangays = [];
          });
          if (newValue != null) {
            final selectedCitiesCode = cities.firstWhere(
              (city) => city['name'] == newValue,
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
      // width: MediaQuery.of(context).size.width * 0.25,
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
        onChanged: (String? newValue) {
          setState(() {
            selectedBarangay = newValue;
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
          controller: otherLocationController,
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
        Gap(10),
      ],
    );
  }

  InputDecoration customInputDecoration() {
    return InputDecoration(
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
    );
  }
}
