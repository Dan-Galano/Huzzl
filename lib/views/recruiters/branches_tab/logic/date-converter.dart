import 'package:intl/intl.dart';

String parseAndFormatDate(String inputDate) {
  // Check if the input matches the expected format
  try {
    DateTime dateTime = DateTime.parse(inputDate);    
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    // Return the date in the desired format
    return formattedDate;
  } catch (e) {
    throw FormatException("Date format not recognized: $inputDate. Please use 'MMMM d, yyyy' format.");
  }
}
