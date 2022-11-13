import 'package:egorka/core/bloc/current_order/current_order_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/widget/mini_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryOrdersPage extends StatelessWidget {
  const HistoryOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RouteOrder> routeOrder = [
      RouteOrder(adress: 'москва солнечная 6'),
      RouteOrder(adress: 'москва межевая 24'),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentOrderBloc>(
          create: (context) => CurrentOrderBloc(),
        ),
      ],
      child: Material(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 30.h,
                              color: Colors.red,
                            ),
                          ),
                          const Align(
                            child: Text(
                              'История',
                              style: CustomTextStyle.black15w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Заказ №123 / 6 марта',
                          style: CustomTextStyle.black15w500,
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 250.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                            child: MiniMapView(routeOrder: routeOrder),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: const [
                            Text(
                              'Дата и время забора',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            SizedBox(width: 10.h),
                            const Text(
                              'Суббота, 7 марта с 13:00 до 14:00',
                              style: CustomTextStyle.black15w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: const [
                            Text(
                              'Маршрут',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: routeOrder.length,
                          itemBuilder: ((context, index) {
                            if (index != routeOrder.length - 1) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/from.png',
                                            height: 25.h,
                                          ),
                                          SizedBox(width: 15.w),
                                          Text(
                                            routeOrder[index].adress,
                                            style: CustomTextStyle.black15w500,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward_rounded,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(width: 15.w),
                                          const Text(
                                            'Посмотреть детали',
                                            style: CustomTextStyle.red15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/to.png',
                                          height: 25.h,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          routeOrder[index].adress,
                                          style: CustomTextStyle.black15w500,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(width: 15.w),
                                        const Text(
                                          'Посмотреть детали',
                                          style: CustomTextStyle.red15,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          children: const [
                            Text(
                              'Кто везёт',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Image.asset(
                                    'assets/images/deliver.jpeg',
                                    height: 80.h,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Евгений',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text(
                                      'Румянцев',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80.w,
                                  width: 80.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_leg.png',
                                        color: Colors.red,
                                        height: 50.h,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Lada Largus / У081МО799',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text(
                                      'Цвет: белый',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          children: const [
                            Text(
                              'Сводная информация',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            SizedBox(width: 10.w),
                            const Text(
                              'Объявленная ценность',
                              style: CustomTextStyle.grey15bold,
                            ),
                            const Spacer(),
                            const Text(
                              '1000 ₽',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            SizedBox(width: 10.w),
                            const Text(
                              'Что везем',
                              style: CustomTextStyle.grey15bold,
                            ),
                            const Spacer(),
                            const Text(
                              'Зарядка',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            SizedBox(width: 10.w),
                            const Text(
                              'Стоимость заказа',
                              style: CustomTextStyle.grey15bold,
                            ),
                            const Spacer(),
                            const Text(
                              '562 ₽',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            SizedBox(width: 10.w),
                            const Text(
                              'Способ оплаты',
                              style: CustomTextStyle.grey15bold,
                            ),
                            const Spacer(),
                            const Text(
                              'Депозит',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
