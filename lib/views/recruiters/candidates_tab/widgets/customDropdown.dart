import 'package:flutter/material.dart';

Widget buildCustomDropdown<T>({
  required T value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
}) {
  return Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffD9D9D9), width: 2),
      borderRadius: BorderRadius.circular(10), // Rounded border
    ),
    child: DropdownButton<T>(
      value: value,
      icon: Icon(Icons.arrow_drop_down),
      underline: SizedBox(),
      isExpanded: false,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Galano',
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    ),
  );
}
