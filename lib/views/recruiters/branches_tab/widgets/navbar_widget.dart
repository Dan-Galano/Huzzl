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