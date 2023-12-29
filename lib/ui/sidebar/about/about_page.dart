import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   title: const Text(
          //     'О приложении',
          //     style: CustomTextStyle.black17w400,
          //   ),
          //   foregroundColor: Colors.red,
          //   elevation: 0.5,
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: EdgeInsets.only(top: 76.h),
                  child: Row(
                    children: [
                      SizedBox(width: 20.w),
                      SvgPicture.asset(
                        'assets/icons/arrow-left.svg',
                        width: 30.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Назад',
                        style: GoogleFonts.manrope(
                          fontSize: 17.h,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // SizedBox(height: 100.h),
              Image.asset(
                'assets/images/egorka_man.png',
                height: 150.h,
              ),
              const Spacer(flex: 1),
              SvgPicture.asset(
                'assets/icons/logo_egorka.svg',
                height: 60.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Версия 0.1',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 20),
              Text(
                'Команда разработки',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              SvgPicture.asset(
                'assets/icons/br.svg',
                height: 25.h,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
