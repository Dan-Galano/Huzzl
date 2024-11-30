import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? prefixText;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final int? maxLines;
  final int? maxChars;
  final int? maxWords; // Maximum word count
  final int? minWords; // Minimum word count
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;

  const CustomTextFormField(
      {Key? key,
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
      this.maxWords, // Initialize maxWords parameter
      this.minWords, // Initialize minWords parameter
      this.obscureText = false,
      this.textInputAction,
      this.onTap,
      this.onEditingComplete})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // Function to count words in the text
  int countWords(String text) {
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (text) {
        if (widget.maxWords != null && countWords(text) > widget.maxWords!) {
          // If maxWords is set and text exceeds maxWords, truncate the text
          String truncatedText =
              text.split(RegExp(r'\s+')).take(widget.maxWords!).join(' ');
          widget.controller.text = truncatedText;
          widget.controller.selection = TextSelection.collapsed(
              offset: truncatedText.length); // Keep cursor at the end
        }

        // Check if minWords is set and the text has fewer words than minWords
        if (widget.minWords != null && countWords(text) < widget.minWords!) {
          // Optionally, show an alert or error message for the user
          // You can use a global key to trigger validation here, or handle it as needed
        }

        if (widget.onChanged != null) {
          widget.onChanged!(text); // Call the original onChanged function
        }
      },
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        prefixText: widget.prefixText,
        isDense: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
        prefixIcon: widget.prefixIcon != null ? widget.prefixIcon : null,
        suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
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
        if (widget.minWords != null &&
            countWords(value ?? '') < widget.minWords!) {
          return 'Please enter at least ${widget.minWords} words.';
        }
        if (widget.maxWords != null &&
            countWords(value ?? '') > widget.maxWords!) {
          return 'Please enter no more than ${widget.maxWords} words.';
        }
        return widget.validator?.call(value);
      },
    );
  }
}
