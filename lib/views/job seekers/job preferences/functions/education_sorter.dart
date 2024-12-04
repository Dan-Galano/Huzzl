import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';

class EducationSorter {
  // Sorts the list of education entries based on their time period, with Present first
  static void sortEducationEntries(List<EducationEntry> educationEntries) {
    educationEntries.sort((a, b) {
      // Handle 'present' entries first
      if (a.isPresent && !b.isPresent) {
        return -1; // 'a' comes before 'b'
      }
      if (!a.isPresent && b.isPresent) {
        return 1; // 'b' comes before 'a'
      }

      // Both are present or both are not, so compare by the full time period
      int comparisonResult = _compareTimePeriods(a, b);
      if (comparisonResult != 0) {
        return comparisonResult; // If time periods differ, return the comparison result
      }

      // If the time periods are the same, compare by 'from' date
      return _compareDates(b.fromSelectedYear, b.fromSelectedMonth,
          a.fromSelectedYear, a.fromSelectedMonth);
    });
  }

  // Helper function to compare the full time periods (from -> to)
  static int _compareTimePeriods(EducationEntry a, EducationEntry b) {
    // If one is present, consider the present year/month as the end
    DateTime endA = a.isPresent
        ? DateTime.now()
        : DateTime(
            a.toSelectedYear ?? 0, _getMonthIndex(a.toSelectedMonth ?? ''));
    DateTime endB = b.isPresent
        ? DateTime.now()
        : DateTime(
            b.toSelectedYear ?? 0, _getMonthIndex(b.toSelectedMonth ?? ''));

    DateTime startA = DateTime(
        a.fromSelectedYear ?? 0, _getMonthIndex(a.fromSelectedMonth ?? ''));
    DateTime startB = DateTime(
        b.fromSelectedYear ?? 0, _getMonthIndex(b.fromSelectedMonth ?? ''));

    // Compare by the most recent (latest) date of start and end
    if (startA.isBefore(startB)) return 1; // 'a' comes after 'b'
    if (startA.isAfter(startB)) return -1; // 'b' comes after 'a'

    if (endA.isBefore(endB)) return 1; // 'a' comes after 'b'
    if (endA.isAfter(endB)) return -1; // 'b' comes after 'a'

    return 0; // If both the start and end are equal
  }

  // Helper function to compare two dates (year and month)
  static int _compareDates(
      int? yearA, String? monthA, int? yearB, String? monthB) {
    // Handle null years first
    if (yearA == null && yearB != null) return 1;
    if (yearA != null && yearB == null) return -1;
    if (yearA == null && yearB == null) return 0;

    // Compare years (descending order)
    if (yearA != yearB) {
      return yearB!.compareTo(yearA!); // Descending year order
    }

    // Compare months only if years are the same (descending order)
    if (monthA != null && monthB != null) {
      int monthAIndex = _getMonthIndex(monthA);
      int monthBIndex = _getMonthIndex(monthB);
      return monthBIndex.compareTo(monthAIndex); // Descending month order
    }

    return 0; // If both years and months are equal
  }

  // Helper function to map month names to numeric indices
  static int _getMonthIndex(String month) {
    switch (month.toLowerCase()) {
      case 'january':
        return 1;
      case 'february':
        return 2;
      case 'march':
        return 3;
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'june':
        return 6;
      case 'july':
        return 7;
      case 'august':
        return 8;
      case 'september':
        return 9;
      case 'october':
        return 10;
      case 'november':
        return 11;
      case 'december':
        return 12;
      default:
        return 0; // Invalid month treated as lowest priority
    }
  }
}
