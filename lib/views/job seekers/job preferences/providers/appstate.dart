import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  Map<String, dynamic>? _selectedLocation;
  Map<String, dynamic>? _selectedPayRate;
  Map<String, dynamic>? _currentResumeOption;
  List? _currentSelectedJobTitles;

  // Getters
  Map<String, dynamic>? get selectedLocation => _selectedLocation;
  Map<String, dynamic>? get selectedPayRate => _selectedPayRate;
  List? get currentSelectedJobTitles => _currentSelectedJobTitles;

  // Setters
  void setSelectedLocation(Map<String, dynamic>? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setSelectedPayRate(Map<String, dynamic>? payRate) {
    _selectedPayRate = payRate;
    notifyListeners();
  }



  void setCurrentSelectedJobTitles(List? jobTitles) {
    _currentSelectedJobTitles = jobTitles;
    notifyListeners();
  }
}
