import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveSizes {
  //huzzl text logo size
  static double huzzlTextLogo(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 60.0;
    if (sizeInfo.isTablet) return 70.0;
    return 80.0; // Desktop
  }

  //submit button size
  static double submitButton(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 14.0;
    if (sizeInfo.isTablet) return 16.0;
    return 17.0; // Desktop
  }

    static double submitButtonPadding(SizingInformation sizeInfo) {
     if (sizeInfo.isMobile) return 18.0;
    if (sizeInfo.isTablet) return 19.0;
    return 20.0; // Desktop
  }

    static double googlePNG(SizingInformation sizeInfo) {
     if (sizeInfo.isMobile) return 20.0;
    if (sizeInfo.isTablet) return 22.0;
    return 24.0; // Desktop
  }

  // Padding sizes
  static double paddingSmall(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 10.0;
    if (sizeInfo.isTablet) return 16.0;
    return 20.0; // Desktop
  }

  static double paddingMedium(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 16.0;
    if (sizeInfo.isTablet) return 20.0;
    return 24.0; // Desktop
  }

  static double paddingLarge(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 20.0;
    if (sizeInfo.isTablet) return 24.0;
    return 30.0; // Desktop
  }

  // Text sizes
  static double titleTextSize(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 20.0;
    if (sizeInfo.isTablet) return 24.0;
    return 30.0; // Desktop
  }

  static double subtitleTextSize(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 12.0;
    if (sizeInfo.isTablet) return 16.0;
    return 18.0; // Desktop
  }

  static double bodyTextSize(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 12.0;
    if (sizeInfo.isTablet) return 14.0;
    return 16.0; // Desktop
  }

  static double noteTextSize(SizingInformation sizeInfo) {
    if (sizeInfo.isMobile) return 10.0;
    if (sizeInfo.isTablet) return 12.0;
    return 14.0; // Desktop
  }
}
