import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';

class EducationSorter {
  // Sorts the list of education entries based on the 'present' status and dates
  static void sortEducationEntries(List<EducationEntry> educationEntries) {
    educationEntries.sort((a, b) {
      // Prioritize 'present' entries
      if (a.isPresent && !b.isPresent) {
        return -1; // 'a' comes before 'b'
      }
      if (!a.isPresent && b.isPresent) {
        return 1; // 'b' comes before 'a'
      }

      // Compare the "from" dates (most recent comes first)
      int fromComparison = _compareDates(b.fromSelectedYear, b.fromSelectedMonth, a.fromSelectedYear, a.fromSelectedMonth);
      if (fromComparison != 0) {
        return fromComparison; // If "from" dates are different, return the comparison result
      }

      // If "from" dates are the same, compare "to" dates
      return _compareDates(b.toSelectedYear, b.toSelectedMonth, a.toSelectedYear, a.toSelectedMonth);
    });
  }

  // Helper function to compare dates (year and month)
  static int _compareDates(int? yearA, String? monthA, int? yearB, String? monthB) {
    if (yearA == null || yearB == null) return 0; // Handle null values gracefully

    // Compare years first
    if (yearA != yearB) {
      return yearB.compareTo(yearA); // Sorting descending by year
    }

    // If years are the same, compare months
    if (monthA != null && monthB != null) {
      int monthAIndex = _getMonthIndex(monthA);
      int monthBIndex = _getMonthIndex(monthB);
      return monthBIndex.compareTo(monthAIndex); // Sorting descending by month
    }

    return 0; // If both years and months are the same, consider them equal
  }

  // Helper function to map month names to indices
  static int _getMonthIndex(String month) {
    switch (month.toLowerCase()) {
      case 'january': return 1;
      case 'february': return 2;
      case 'march': return 3;
      case 'april': return 4;
      case 'may': return 5;
      case 'june': return 6;
      case 'july': return 7;
      case 'august': return 8;
      case 'september': return 9;
      case 'october': return 10;
      case 'november': return 11;
      case 'december': return 12;
      default: return 0; // In case of invalid month input, treat it as the first month
    }
  }
}
