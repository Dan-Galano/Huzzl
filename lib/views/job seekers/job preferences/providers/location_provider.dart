import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationProvider extends ChangeNotifier {
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  String? selectedRegionName;
  String? selectedProvinceName;
  String? selectedCityName;
  String? selectedBarangayName;
  TextEditingController otherLocationController = TextEditingController();

  List regions = [];
  List provinces = [];
  List cities = [];
  List barangays = [];

  // Fetch regions from API
  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      regions = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Fetch provinces for the selected region
  Future<void> fetchProvincesOrCities(String regionCode) async {
    if (regionCode == '130000000') {
      await fetchCitiesForRegion(regionCode);
    } else {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
      if (response.statusCode == 200) {
        provinces = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        cities = [];
        barangays = [];
        selectedProvince = null;
        selectedCity = null;
        selectedBarangay = null;
        notifyListeners();
      } else {
        throw Exception('Failed to load provinces');
      }
    }
  }

  // Fetch cities for NCR
  Future<void> fetchCitiesForRegion(String regionCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/regions/$regionCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      barangays = [];
      selectedCity = null;
      selectedBarangay = null;
      notifyListeners();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Fetch cities by province code
  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      barangays = [];
      selectedCity = null;
      selectedBarangay = null;
      notifyListeners();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Fetch barangays by city code
  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
    if (response.statusCode == 200) {
      barangays = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      selectedBarangay = null;
      notifyListeners();
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  // Set location data
  void setLocationData(Map<String, dynamic> locationData) {
    selectedRegion = locationData['regionCode'];
    selectedProvince = locationData['provinceCode'];
    selectedCity = locationData['cityCode'];
    selectedBarangay = locationData['barangayCode'];
    otherLocationController.text = locationData['otherLocation'] ?? '';

    // Set names based on the selected codes
    selectedRegionName = _getRegionNameByCode(selectedRegion);
    selectedProvinceName = _getProvinceNameByCode(selectedProvince);
    selectedCityName = _getCityNameByCode(selectedCity);
    selectedBarangayName = _getBarangayNameByCode(selectedBarangay);

    notifyListeners();
  }

// Helper function to get the name of the region by its code
  String? _getRegionNameByCode(String? regionCode) {
    return regions.firstWhere(
      (region) => region['code'] == regionCode,
      orElse: () => {'name': null},
    )['name'];
  }

// Helper function to get the name of the province by its code
  String? _getProvinceNameByCode(String? provinceCode) {
    return provinces.firstWhere(
      (province) => province['code'] == provinceCode,
      orElse: () => {'name': null},
    )['name'];
  }

// Helper function to get the name of the city by its code
  String? _getCityNameByCode(String? cityCode) {
    return cities.firstWhere(
      (city) => city['code'] == cityCode,
      orElse: () => {'name': null},
    )['name'];
  }

// Helper function to get the name of the barangay by its code
  String? _getBarangayNameByCode(String? barangayCode) {
    return barangays.firstWhere(
      (barangay) => barangay['code'] == barangayCode,
      orElse: () => {'name': null},
    )['name'];
  }

  // Get current location data
  Map<String, dynamic> getLocationData() {
    return {
      'regionCode': selectedRegion,
      'regionName': selectedRegionName,
      'provinceCode': selectedProvince,
      'provinceName': selectedProvinceName,
      'cityCode': selectedCity,
      'cityName': selectedCityName,
      'barangayCode': selectedBarangay,
      'barangayName': selectedBarangayName,
      'otherLocation': otherLocationController.text,
    };
  }
}
