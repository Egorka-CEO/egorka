import 'package:egorka/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
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

  static const AppTextStyle red15 = AppTextStyle(
    fontSize: 14,
    color: Colors.red,
    fontWeight: FontWeight.w400,
  );

  static const AppTextStyle black17w400 = AppTextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const AppTextStyle black15w700 = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const AppTextStyle grey14w400 = AppTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static TextStyle grey15bold = GoogleFonts.manrope(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: helperTextColor,
  );

  static const AppTextStyle grey15 = AppTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: helperTextColor,
  );

  static const AppTextStyle textHintStyle = AppTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 195, 195, 195),
  );
}
