import 'package:egorka/helpers/router.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAuthView extends StatelessWidget {
  const MainAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/egorka_auth.jpeg',
            height: MediaQuery.of(context).size.height - 330.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 370.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Егорка нужен прямо сейчас?',
                    style: GoogleFonts.manrope(
                      fontSize: 36.h,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Мы найдем и пришлем его в течение часа!',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CustomButton(
                    title: 'Регистрация',
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoute.registration,
                        arguments: false,
                      );
                    },
                  ),
                  SizedBox(height: 36.h),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.auth);
                      },
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Уже есть аккаунт? ',
                              style: GoogleFonts.manrope(
                                fontSize: 17.h,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Войти',
                              style: GoogleFonts.manrope(
                                fontSize: 17.h,
                                color: const Color.fromRGBO(122, 150, 249, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
