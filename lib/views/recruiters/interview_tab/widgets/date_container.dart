import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DateContainer extends StatelessWidget {
  const DateContainer({
    super.key,
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
      width: MediaQuery.of(context).size.width * 0.15,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor, // Light orange background color
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: outlineBorderColor, width: 1), // Orange border
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: outlineBorderColor,
            size: 18,
          ),
          const Gap(10),
          Text(
            date,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 12,
              color: outlineBorderColor,
            ),
          ),
        ],
      ),
    );
  }
}
