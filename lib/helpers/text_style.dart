import 'package:flutter/material.dart';

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) : super(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: '.SF UI Display',
          color: color,
        );
}

class CustomTextStyle {
  static const AppTextStyle white15w600 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const AppTextStyle black15w500 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}
