import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? prefixText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxChars;
  final int? maxWords;  // Maximum word count
  final int? minWords;  // Minimum word count

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLines,
    this.maxChars,
    this.maxWords,  // Initialize maxWords parameter
    this.minWords,  // Initialize minWords parameter
    this.obscureText = false,
  }) : super(key: key);

  // Function to count words in the text
  int countWords(String text) {
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (text) {
        if (maxWords != null && countWords(text) > maxWords!) {
          // If maxWords is set and text exceeds maxWords, truncate the text
          String truncatedText = text.split(RegExp(r'\s+')).take(maxWords!).join(' ');
          controller.text = truncatedText;
          controller.selection = TextSelection.collapsed(offset: truncatedText.length);  // Keep cursor at the end
        }

        // Check if minWords is set and the text has fewer words than minWords
        if (minWords != null && countWords(text) < minWords!) {
          // Optionally, show an alert or error message for the user
          // You can use a global key to trigger validation here, or handle it as needed
        }

        if (onChanged != null) {
          onChanged!(text);  // Call the original onChanged function
        }
      },
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixText: prefixText,
        isDense: true,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
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
      validator: (value) {
        // If minWords is set, validate the number of words
        if (minWords != null && countWords(value ?? '') < minWords!) {
          return 'Please enter at least $minWords words.';
        }
        if (maxWords != null && countWords(value ?? '') > maxWords!) {
          return 'Please enter no more than $maxWords words.';
        }
        return validator?.call(value);
      },
    );
  }
}
