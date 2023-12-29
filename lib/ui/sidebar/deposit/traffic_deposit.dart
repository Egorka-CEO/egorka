import 'dart:async';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/ui/sidebar/deposit/add_deposit.dart';
import 'package:egorka/ui/sidebar/deposit/item_traffic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TrafficDeposit extends StatefulWidget {
  @override
  State<TrafficDeposit> createState() => _TrafficDepositState();
}

class _TrafficDepositState extends State<TrafficDeposit> {
  @override
  void dispose() {
    tabBarController.close();
    super.dispose();
  }

  final tabBarController = StreamController<int>();
  int currentView = 0;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   elevation: 0.5,
      //   title: const Text(
      //     'Депозит',
      //     style: CustomTextStyle.black17w400,
      //   ),
      //   leading: GestureDetector(
      //     onTap: () => Navigator.of(context).pop(),
      //     child: const Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.red,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: Column(
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
          SizedBox(
            height: 100.h,
            child: StreamBuilder<int>(
              stream: tabBarController.stream,
              initialData: 0,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 20.w,
                  ),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tabBarController.add(0);
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              height: 42.h,
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color: snapshot.data! == 0
                                      ? Color.fromRGBO(255, 102, 102, 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(32.r)),
                              child: Center(
                                child: Text(
                                  'Пополнить',
                                  style: snapshot.data! == 0
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tabBarController.add(1);
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color: snapshot.data! == 1
                                      ? Color.fromRGBO(255, 102, 102, 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(32.r)),
                              child: Center(
                                child: Text(
                                  'Все счета',
                                  style: snapshot.data! == 1
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tabBarController.add(2);
                              pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: snapshot.data! == 2
                                    ? Color.fromRGBO(255, 102, 102, 1)
                                    : null,
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Пополнения',
                                  style: snapshot.data! == 2
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tabBarController.add(3);
                              pageController.jumpToPage(3);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color: snapshot.data! == 3
                                      ? Color.fromRGBO(255, 102, 102, 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(32.r)),
                              child: Center(
                                child: Text(
                                  'Списания',
                                  style: snapshot.data! == 3
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: AddDeposit(0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ItemTraffic(
                      Filter(type: 'Bill'),
                      page: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ItemTraffic(
                      Filter(direction: 'Debet'),
                      page: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ItemTraffic(
                      Filter(direction: 'Credit'),
                      page: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
