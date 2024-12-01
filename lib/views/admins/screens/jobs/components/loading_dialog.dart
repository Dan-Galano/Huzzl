import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future showLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.transparent,
        content: Container(
          width: 105,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              children: [
                const Gap(10),
                Image.asset(
                  'assets/images/gif/huzzl_loading.gif',
                  height: 100,
                  width: 100,
                ),
                const Gap(10),
                const Text(
                  "Editing information...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFfd7206),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}