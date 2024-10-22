import 'package:intl/intl.dart';

String parseAndFormatDate(String inputDate) {
  // Check if the input matches the expected format
  try {
    DateTime dateTime = DateFormat("MMMM d, yyyy").parseStrict(inputDate);
    // Return the date in the desired format
    return DateFormat("MMMM d, yyyy").format(dateTime);
  } catch (e) {
    throw FormatException("Date format not recognized: $inputDate. Please use 'MMMM d, yyyy' format.");
  }
}
