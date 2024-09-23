import 'package:flutter/material.dart';

Widget navBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Image.asset('assets/images/huzzl.png', width: 80),
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/message-icon.png', width: 20),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/notif-icon.png',
                width: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/user-icon.png',
                width: 20,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

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
  }
  return const InputDecoration();
}
