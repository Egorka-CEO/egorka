import 'dart:async';
import 'package:egorka/helpers/app_colors.dart';
import 'package:egorka/ui/auth/reg_page.dart';
import 'package:egorka/ui/auth/reg_page_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MainRegPage extends StatefulWidget {
  final bool flag;
  const MainRegPage({super.key, required this.flag});

  @override
  State<MainRegPage> createState() => _MainRegPageState();
}

class _MainRegPageState extends State<MainRegPage> {
  late PageController pageController;
  final streamController = StreamController<int>();
  bool openKeyboardFirst = false;
  bool openKeyboardSecond = false;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(MediaQuery.of(context).viewInsets.toString()); // FIXME(kki): remove after prod
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
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
      body: StreamBuilder<int>(
          stream: streamController.stream,
          initialData: 0,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: SvgPicture.asset(
                  //         'assets/icons/logo_egorka.svg',
                  //         height: 40.h,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 20.h),
                  SizedBox(
                    height: 150.h,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 20.w),
                            Text(
                              'Кем вы являетесь?',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 36.h,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    streamController.add(0);
                                    pageController.animateToPage(
                                      0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuint,
                                    );
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
                                    pageController.animateToPage(
                                      1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuint,
                                    );
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
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: snapshot.data! == 0
                        ? openKeyboardFirst
                            ? 1140.h
                            : 820.h
                        : openKeyboardSecond
                            ? 1630.h
                            : 1310.h,
                    child: PageView(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        RegPage(
                          openKeyboard: (p0) {
                            setState(() {
                              openKeyboardFirst = p0;
                            });
                          },
                        ),
                        RegPageCompany(
                          openKeyboard: (p0) {
                            setState(() {
                              openKeyboardSecond = p0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
