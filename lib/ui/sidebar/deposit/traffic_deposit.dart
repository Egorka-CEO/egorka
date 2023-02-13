import 'dart:async';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/ui/sidebar/deposit/add_deposit.dart';
import 'package:egorka/ui/sidebar/deposit/item_traffic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0.5,
          title: const Text(
            'Депозит',
            style: CustomTextStyle.black15w500,
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            StreamBuilder<int>(
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
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tabBarController.add(0);
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.ease);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color:
                                      snapshot.data! == 0 ? Colors.red : null,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: Text(
                                  'Пополнить',
                                  style: snapshot.data! == 0
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black15w500
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
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.ease);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color:
                                      snapshot.data! == 1 ? Colors.red : null,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: Text(
                                  'Все счета',
                                  style: snapshot.data! == 1
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black15w500
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
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.ease);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color:
                                      snapshot.data! == 2 ? Colors.red : null,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Пополнения',
                                  style: snapshot.data! == 2
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black15w500
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
                              pageController.animateToPage(3,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.ease);
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  color:
                                      snapshot.data! == 3 ? Colors.red : null,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Списания',
                                  style: snapshot.data! == 3
                                      ? CustomTextStyle.white15w600
                                          .copyWith(fontSize: 13.sp)
                                      : CustomTextStyle.black15w500
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 30.w),
                child: SizedBox(
                  height: 400.h,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      AddDeposit(),
                      ItemTraffic(Filter(type: 'Invoice')),
                      ItemTraffic(Filter(direction: 'Debet')),
                      ItemTraffic(Filter(direction: 'Credit')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
