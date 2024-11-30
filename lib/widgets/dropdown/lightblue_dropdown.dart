import 'package:flutter/material.dart';

class LightBlueTextFieldDropdown extends StatelessWidget {
  final double? width;
  final TextEditingController controller;
  final bool obscureText;

  final bool isDropdown;
  final String? dropdownValue;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onChanged;
  final TextStyle? itemTextStyle;

  LightBlueTextFieldDropdown({
    this.width,
    required this.controller,
    required this.obscureText,
    this.isDropdown = false,
    this.dropdownValue,
    this.dropdownItems,
    this.onChanged,
    this.itemTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: isDropdown
          ? DropdownButtonFormField<String>(
              value: dropdownValue,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 14.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: dropdownItems?.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: itemTextStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Galano',
                          color: Color(0xFF8E8E8E),
                        ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: Image.asset(
                'assets/images/dropdown.png',
                width: 15,
                height: 15,
              ),
            )
          : TextField(
              obscureText: obscureText,
              style: TextStyle(
                fontSize: 15,
              ),
              controller: controller,
              cursorColor: Color.fromARGB(255, 58, 63, 76),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 14.0,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF),
                    width: 1.5,
                  ),
                ),
              ),
            ),
    );
  }
}
