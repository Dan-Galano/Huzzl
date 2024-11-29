import 'package:flutter/material.dart';

class EducationEntry {
  TextEditingController degreeController = TextEditingController();
  TextEditingController institutionNameController = TextEditingController();
  TextEditingController institutionAddressController = TextEditingController();
  TextEditingController honorsOrAwardsController = TextEditingController();
  
  String degree = '';
  String institutionName = '';
  String institutionAddress = '';
  String honorsOrAwards = '';
  String? fromSelectedMonth;
  int? fromSelectedYear;
  String? toSelectedMonth;
  int? toSelectedYear;
  bool isPresent = false;

  EducationEntry();
}
