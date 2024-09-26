import 'package:flutter/material.dart';



InputDecoration searchTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: const Icon(Icons.search),
    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    isDense: true,
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
  );
}

InputDecoration inputTextFieldDecoration(int option) {
  //option 1: no location prefix icon. just plain text field
  //option 2: with location prefix icon
  //option 3: with hintText

  if (option == 1) {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      isDense: true,
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
    );
  } else if (option == 2) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.location_on_outlined),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      isDense: true,
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
    );
  } else if (option == 3){
     return InputDecoration(
      hintText: 'Street Name, Building, House No.',
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      isDense: true,
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
    );
  }
  return const InputDecoration();
}

OutlineInputBorder outlinedInputBorder(){
  return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD1E1FF),
          width: 1.5,
        ),
      );
}

InputDecoration customHintTextInputDecoration(String hintTxt) {
  return InputDecoration(
      hintText: hintTxt,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      isDense: true,
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
    );
}