import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSelectorPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(Map<String, dynamic>) onSaveLocation;

  const LocationSelectorPage({
    Key? key,
    required this.nextPage,
    required this.onSaveLocation,
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
    fetchRegions(); // Fetch regions when app starts
  }

  @override
  void dispose() {
    otherLocationInformation.dispose();
    super.dispose();
  }

  // void _submitLocationForm() {
  //   Map<String, dynamic> locationData = {
  //     'region': selectedRegion,
  //     'province': selectedProvince,
  //     'city': selectedCity,
  //     'barangay': selectedBarangay,
  //     'otherLocation': otherLocationInformation.text,
  //   };
  //   widget.onSaveLocation(locationData);
  //   widget.nextPage();
  // }
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

    Map<String, dynamic> locationData = {
      'region': selectedRegionData?['name'],
      'province': selectedProvinceData?['name'],
      'city': selectedCityData?['name'],
      'barangay': selectedBarangayData?['name'],
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
        selectedProvince = null;
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
        selectedCity = null;
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
        selectedBarangay = null;
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
            const Text('1/3', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            const Text('Where are you located?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('We use this to match you with jobs nearby',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Region'),
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
                  fetchProvinces(value!);
                });
              },
            ),
            const SizedBox(height: 16.0),
            if (selectedRegion != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Province'),
                value: selectedProvince,
                items: provinces.map<DropdownMenuItem<String>>((province) {
                  return DropdownMenuItem<String>(
                    value: province['code'],
                    child: Text(province['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                    cities = [];
                    fetchCities(value!);
                  });
                },
              ),
            const SizedBox(height: 16.0),
            if (selectedProvince != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Select City/Municipality'),
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
                    fetchBarangays(value!);
                  });
                },
              ),
            const SizedBox(height: 16.0),
            if (selectedCity != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Barangay'),
                value: selectedBarangay,
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
            const SizedBox(height: 16.0),
            if (selectedBarangay != null)
              TextField(
                controller: otherLocationInformation,
                decoration: const InputDecoration(
                    labelText: 'Street Name, Building, House No.'),
              ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submitLocationForm,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
