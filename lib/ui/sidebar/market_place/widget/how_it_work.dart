import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget howItWork(
  BuildContext context,
  GlobalKey howItWorkKey,
) {
  return GestureDetector(
    onTap: () => showTipWork(
      context,
      getWidgetPosition(howItWorkKey),
      (index) {
        Navigator.pop(context);
      },
    ),
    child: Text(
      'Типы доставок',
      key: howItWorkKey,
      style: GoogleFonts.manrope(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(255, 102, 102, 1),
      ),
    ),
  );
}
