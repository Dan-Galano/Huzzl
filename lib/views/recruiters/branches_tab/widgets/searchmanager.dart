import 'package:flutter/material.dart';

class ControllerManager {
  static final ControllerManager _instance = ControllerManager._internal();

  factory ControllerManager() {
    return _instance;
  }

  ControllerManager._internal();

  final TextEditingController searchManagerController = TextEditingController();
}
