import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';

class LocationSelectorPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(Map<String, dynamic>) onSaveLocation;
  final Map<String, dynamic>? currentLocation;
  final int noOfPages;
  // final ValueChanged<String?> onselectedRegionChanged;
  const LocationSelectorPage({
    Key? key,
    required this.nextPage,
    required this.onSaveLocation,
    required this.currentLocation,
    required this.noOfPages,
  }) : super(key: key);

  @override
  State<LocationSelectorPage> createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> {
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  final TextEditingController otherLocationInformation =
      TextEditingController();

  List regions = [];
  List provinces = [];
  List cities = [];
  List barangays = [];

  @override
  void initState() {
    super.initState();

    // If currentLocation is available, pre-fill the data
    if (widget.currentLocation != null) {
      final location = widget.currentLocation!;
      fetchRegions();
      // Set the selected values from the currentLocation
      selectedRegion = location['regionCode'];
      selectedProvince = location['provinceCode'];
      selectedCity = location['cityCode'];
      selectedBarangay = location['barangayCode'];
      otherLocationInformation.text = location['otherLocation'] ?? '';

      // Fetch provinces if currentLocation has a regionCode
      if (selectedRegion != null) {
        fetchProvinces(selectedRegion!).then((_) {
          // Fetch cities if a province is selected
          if (selectedProvince != null) {
            fetchCities(selectedProvince!).then((_) {
              // Fetch barangays if a city is selected
              if (selectedCity != null) {
                fetchBarangays(selectedCity!);
              }
            });
          }
        });
      }
    } else {
      fetchRegions(); // No pre-filled data, so fetch regions initially
    }
  }

  @override
  void dispose() {
    otherLocationInformation.dispose();
    super.dispose();
  }

  void _submitLocationForm() {
    final selectedRegionData = regions.firstWhere(
        (region) => region['code'] == selectedRegion,
        orElse: () => null);
    final selectedProvinceData = provinces.firstWhere(
        (province) => province['code'] == selectedProvince,
        orElse: () => null);
    final selectedCityData = cities
        .firstWhere((city) => city['code'] == selectedCity, orElse: () => null);
    final selectedBarangayData = barangays.firstWhere(
        (barangay) => barangay['code'] == selectedBarangay,
        orElse: () => null);

    if (selectedRegionData == null ||
        selectedProvinceData == null ||
        selectedCityData == null ||
        selectedBarangayData == null ||
        otherLocationInformation.text.trim().isEmpty) {
      return;
    }
    Map<String, dynamic> locationData = {
      'region': selectedRegionData['name'],
      'regionCode': selectedRegionData['code'],
      'province': selectedProvinceData['name'],
      'provinceCode': selectedProvinceData['code'],
      'city': selectedCityData['name'],
      'cityCode': selectedCityData['code'],
      'barangay': selectedBarangayData['name'],
      'barangayCode': selectedBarangayData['code'],
      'otherLocation': otherLocationInformation.text,
    };

    widget.onSaveLocation(locationData);
    widget.nextPage();
  }

  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      setState(() {
        regions = jsonDecode(response.body);

        // Check if currentLocation contains regionCode and set selectedRegion accordingly
        if (widget.currentLocation != null &&
            widget.currentLocation!['regionCode'] != null) {
          selectedRegion = widget.currentLocation!['regionCode'];
        }
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
        // If a province was previously selected, maintain that selection
        if (widget.currentLocation != null &&
            widget.currentLocation!['provinceCode'] != null) {
          selectedProvince = widget.currentLocation!['provinceCode'];
        } else {
          selectedProvince = null;
        }
        cities = [];
        selectedCity = null;
        barangays = [];
        selectedBarangay = null;
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
        // If a city was previously selected, maintain that selection
        if (widget.currentLocation != null &&
            widget.currentLocation!['cityCode'] != null) {
          selectedCity = widget.currentLocation!['cityCode'];
        } else {
          selectedCity = null;
        }
        barangays = [];
        selectedBarangay = null;
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
        // If a barangay was previously selected, maintain that selection
        if (widget.currentLocation != null &&
            widget.currentLocation!['barangayCode'] != null) {
          selectedBarangay = widget.currentLocation!['barangayCode'];
        } else {
          selectedBarangay = null;
        }
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
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 400.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1/${widget.noOfPages}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w100,
                  ),
                ),
                TextButton(
                  child: Text("Skip all",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Where are you located?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('We use this to match you with jobs nearby',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Select Region',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              value: regions.any((region) => region['code'] == selectedRegion)
                  ? selectedRegion
                  : null, // Ensure selectedRegion is valid or reset to null
              items: regions.map<DropdownMenuItem<String>>((region) {
                return DropdownMenuItem<String>(
                  value: region['code'],
                  child: Text(region['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;

                  // Reset dependent fields
                  selectedProvince = null;
                  provinces = [];
                  selectedCity = null;
                  cities = [];
                  selectedBarangay = null;
                  barangays = [];

                  if (value != null) {
                    fetchProvinces(
                        value); // Fetch provinces for the selected region
                  }
                });
              },
            ),

            const SizedBox(height: 16.0),
            //  if (selectedRegion != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Select Province',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              value: provinces
                      .any((province) => province['code'] == selectedProvince)
                  ? selectedProvince
                  : null, // Ensure selectedProvince is valid or reset to null
              items: provinces.map<DropdownMenuItem<String>>((province) {
                return DropdownMenuItem<String>(
                  value: province['code'],
                  child: Text(province['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;

                  // Reset dependent fields
                  selectedCity = null;
                  cities = [];
                  selectedBarangay = null;
                  barangays = [];

                  if (value != null) {
                    fetchCities(
                        value); // Fetch cities for the selected province
                  }
                });
              },
            ),

            const SizedBox(height: 16.0),
            // if (selectedProvince != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Select City/Municipality',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              value: cities.any((city) => city['code'] == selectedCity)
                  ? selectedCity
                  : null, // Ensure selectedCity is valid or reset to null
              items: cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city['code'],
                  child: Text(city['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;

                  // Reset dependent fields
                  selectedBarangay = null;
                  barangays = [];

                  if (value != null) {
                    fetchBarangays(
                        value); // Fetch barangays for the selected city
                  }
                });
              },
            ),

            const SizedBox(height: 16.0),
            // if (selectedCity != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Select Barangay',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              value: barangays
                      .any((barangay) => barangay['code'] == selectedBarangay)
                  ? selectedBarangay
                  : null, // Ensure selectedBarangay is valid or reset to null
              items: barangays.map<DropdownMenuItem<String>>((barangay) {
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

            const SizedBox(height: 30),
            // if (selectedBarangay != null)
            TextField(
              controller:
                  otherLocationInformation, // Already initialized in initState
              decoration: const InputDecoration(
                  labelText: 'Street Name, Building, House No.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text("Skip",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    selectedRegion = null;
                    selectedProvince = null;
                    selectedCity = null;
                    selectedBarangay = null;
                    otherLocationInformation.clear();
                    regions = [];
                    provinces = [];
                    cities = [];
                    barangays = [];

                    Map<String, dynamic> locationData = {};

                    widget.onSaveLocation(locationData);
                    widget.nextPage();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 130,
                    child: BlueFilledCircleButton(
                      onPressed: _submitLocationForm,
                      text: 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
