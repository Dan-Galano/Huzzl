import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/02%20minimum_pay.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationSelectorPage extends StatefulWidget {
  final VoidCallback nextPage;

  const LocationSelectorPage({
    super.key,
    required this.nextPage,
  });

  @override
  State<LocationSelectorPage> createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> {
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
    fetchRegions(); // Fetch regions when app starts
  }

  void _submitLocationForm() {
    // if (_formKey.currentState!.validate()) {
    //   widget.nextPage();
    // }
    widget.nextPage();
  }

  // Fetch regions from the API
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

  // Fetch provinces by region code
  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        selectedProvince = null; // Reset province
        cities = [];
        selectedCity = null; // Reset city
        barangays = [];
        selectedBarangay = null; // Reset barangay
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
        selectedCity = null; // Reset city
        barangays = [];
        selectedBarangay = null; // Reset barangay
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
        selectedBarangay = null; // Reset barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: AppBar(
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     title: Image.asset(
      //       'assets/images/huzzl.png',
      //       width: 80,
      //     ),
      //     actions: [
      //       Padding(
      //         padding: const EdgeInsets.only(right: 16.0),
      //         child: IconButton(
      //           icon: Image.asset(
      //             'assets/images/account.png',
      //             width: 25,
      //             height: 25,
      //           ),
      //           onPressed: () {
      //             // action
      //           },
      //         ),
      //       ),
      //     ],
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         border: Border(
      //           bottom: BorderSide(
      //             color: Color(0xffD9D9D9),
      //             width: 3.0,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40), // Space for the icon
                    Text(
                      '1/3',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Where are you located?',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'We use this to match you with jobs nearby',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 30),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Region',
                        labelStyle: TextStyle(
                          color: Color(0xff373030),
                          fontSize: 15.0,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                      ),
                      value: selectedRegion,
                      items: regions.map<DropdownMenuItem<String>>((region) {
                        return DropdownMenuItem<String>(
                          value: region['code'],
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
                          fetchProvinces(value);
                        }
                      },
                    ),
                    SizedBox(height: 16.0),

                    // Show Province Dropdown only when a region is selected
                    if (selectedRegion != null)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Province',
                          labelStyle: TextStyle(
                            color: Color(0xff373030),
                            fontSize: 15.0,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                        ),
                        value: selectedProvince,
                        items:
                            provinces.map<DropdownMenuItem<String>>((province) {
                          return DropdownMenuItem<String>(
                            value: province['code'],
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
                            fetchCities(value);
                          }
                        },
                      ),
                    SizedBox(height: 16.0),
                    // Show City Dropdown only when a province is selected
                    if (selectedProvince != null)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select City/Municipality',
                          labelStyle: TextStyle(
                            color: Color(0xff373030),
                            fontSize: 15.0,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                        ),
                        value: selectedCity,
                        items: cities.map<DropdownMenuItem<String>>((city) {
                          return DropdownMenuItem<String>(
                            value: city['code'],
                            child: Text(city['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                            barangays = [];
                            selectedBarangay = null;
                          });
                          if (value != null) {
                            fetchBarangays(value);
                          }
                        },
                      ),
                    // Show Barangay Dropdown only when a city is selected
                    SizedBox(height: 16.0),
                    if (selectedCity != null)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Barangay',
                          labelStyle: TextStyle(
                            color: Color(0xff373030),
                            fontSize: 15.0,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                        ),
                        value: selectedBarangay,
                        items:
                            barangays.map<DropdownMenuItem<String>>((barangay) {
                          return DropdownMenuItem<String>(
                            value: barangay['code'],
                            child: Text(barangay['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBarangay = value;
                          });
                        },
                      ),

                    if (selectedBarangay != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: otherLocationInformation,
                            decoration: grayHintTextInputDecoration(
                                "Street Name, Building, House No."),
                            validator: (value) {
                              if (value!.isEmpty || value == null) {
                                return "This field is required.";
                              }
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => JobseekerMainScreen(),
                              ));
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 17,
                                  color: Color(0xffFE9703)),
                            )),
                        Gap(10),
                        SizedBox(
                          width: 130,
                          child: BlueFilledCircleButton(
                            onPressed: () => _submitLocationForm(),
                            text: 'Next',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
