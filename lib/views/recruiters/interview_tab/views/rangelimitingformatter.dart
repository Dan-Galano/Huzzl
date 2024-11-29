import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RangeLimitingTextInputFormatter extends TextInputFormatter {
  final int max;
  RangeLimitingTextInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value == null || value < 0 || value > max) {
      return oldValue;
    }
    return newValue;
  }
}
