import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DateContainer extends StatelessWidget {
  DateContainer({super.key,
  required this.date,
    required this.backgroundColor,
    required this.outlineBorderColor,
  });

  final String date;
  final Color backgroundColor;
  final Color outlineBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: backgroundColor, // Light orange background color
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: outlineBorderColor, width: 1), // Orange border
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: outlineBorderColor,
                      ),
                      const Gap(10),
                      Text(
                        date,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: outlineBorderColor,
                        ),
                      ),
                    ],
                  ),
                );
  }
}