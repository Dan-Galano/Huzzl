import 'package:flutter/material.dart';

class TimePeriodPicker extends StatelessWidget {
  final String? selectedMonth; // Holds the current selected month
  final int? selectedYear; // Holds the current selected year
  final void Function(String? selectedMonth)? onMonthChanged;
  final void Function(int? selectedYear)? onYearChanged;
  final FormFieldValidator<String>? validatorMonth; // Validator for Month
  final FormFieldValidator<int>? validatorYear; // Validator for Year

  const TimePeriodPicker({
    Key? key,
    this.selectedMonth, // Initialize the selected month
    this.selectedYear, // Initialize the selected year
    this.onMonthChanged,
    this.onYearChanged,
    this.validatorMonth, // Validator for Month
    this.validatorYear, // Validator for Year
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final List<int> years = List.generate(
      DateTime.now().year - 1950 + 1,
      (index) => 1950 + index,
    ).reversed.toList();

    return Row(
      children: [
        // Month Dropdown
        Expanded(
          child: DropdownButtonFormField<String>(
            value: months.contains(selectedMonth) ? selectedMonth : null,
            hint: Text("Select Month"),
            onChanged: onMonthChanged,
            validator: validatorMonth, // Add validator for month
            items: months.map((month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(month),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16), // Space between the dropdowns

        // Year Dropdown
        Expanded(
          child: DropdownButtonFormField<int>(
            value: years.contains(selectedYear) ? selectedYear : null,
            hint: Text("Select Year"),
            onChanged: onYearChanged,
            validator: validatorYear, // Add validator for year
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
