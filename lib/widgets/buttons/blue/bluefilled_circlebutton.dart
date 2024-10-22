import 'package:flutter/material.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BlueFilledCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;

  BlueFilledCircleButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Container(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0038FF),
            padding:
                EdgeInsets.all(ResponsiveSizes.submitButtonPadding(sizeInfo)),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveSizes.paddingLarge(sizeInfo)),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveSizes.submitButton(sizeInfo),
              color: Colors.white,
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}
