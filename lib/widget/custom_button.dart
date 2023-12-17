import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scale_button/scale_button.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      bound: 0.02,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 64.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 102, 102, 1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 17.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(
              'assets/icons/arrow-right.svg',
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
