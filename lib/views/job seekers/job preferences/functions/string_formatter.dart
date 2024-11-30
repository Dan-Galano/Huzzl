extension StringFormatter on String {
  // Capitalize the first letter and make the rest lowercase
  String toCapitalCase() {
    if (this == null || this.isEmpty) return '';
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }

  // Capitalize the first letter of each word
  String toTitleCase() {
    if (this == null || this.isEmpty) return '';
    List<String> words = this.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].toCapitalCase(); // Use toCapitalCase for each word
    }
    return words.join(' ');
  }

  // Convert to lowercase and remove extra spaces
  String toLowerCaseTrimmed() {
    return this.trim().toLowerCase();
  }

  // Convert to uppercase
  String toUpperCaseTrimmed() {
    return this.trim().toUpperCase();
  }

  // Format a phone number (example: format to (xxx) xxx-xxxx)
  String toPhoneNumberFormat() {
    // Just an example. You can update the regex for more formats.
    String cleaned = this.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6, 10)}';
    }
    return this;
  }

  // Capitalize first letter of each sentence
  String capitalizeEachSentence() {
    if (this.isEmpty) return '';
    List<String> sentences = this.split('. ');
    for (int i = 0; i < sentences.length; i++) {
      sentences[i] = sentences[i].toCapitalCase(); // Capitalize each sentence
    }
    return sentences.join('. ');
  }

  // Remove extra spaces between words
  String removeExtraSpaces() {
    return this.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

 

  // Check if the string is a valid phone number (basic check)
  bool isValidPhoneNumber() {
    return RegExp(r'^(09|\+639)\d{9}$').hasMatch(this);
  }
}
