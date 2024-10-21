import 'package:flutter/material.dart';

Widget buildCustomCheckbox({
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: Colors.white,
          activeColor: Color(0xFFFF9800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
