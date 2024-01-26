import 'dart:async';
import 'package:egorka/helpers/app_colors.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/ui/auth/auth_page.dart';
import 'package:egorka/ui/auth/auth_page_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  PageController pageController = PageController();
  final streamController = StreamController<int>();

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: GestureDetector(
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
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: StreamBuilder<int>(
                  stream: streamController.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              streamController.add(0);
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              height: 60.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: snapshot.data == 0
                                    ? const Color.fromRGBO(255, 102, 102, 1)
                                    : AppColors.grey,
                              ),
                              child: Text(
                                'Физ. Лицо',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.h,
                                  color: snapshot.data == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              streamController.add(1);
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              height: 60.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: snapshot.data == 1
                                    ? const Color.fromRGBO(255, 102, 102, 1)
                                    : AppColors.grey,
                              ),
                              child: Text(
                                'ИП или ООО',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.h,
                                  color: snapshot.data == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Expanded(
              child: SizedBox(
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AuthPage(),
                    const AuthPageCompany(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
