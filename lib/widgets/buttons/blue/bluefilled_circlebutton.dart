import 'package:flutter/material.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BlueFilledCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final Color color;

  BlueFilledCircleButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.color = const Color(0xFF0038FF), 
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Container(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
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
