import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext?.findRenderObject() as RenderBox;

  return renderBox.localToGlobal(Offset.zero);
}

void showTipPallet(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 30.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'На паллете 120х80 можно расположить 16 коробок размером 60х40х40. Итого высота вместе с паллетой составит 175 см – это допустимое значение маркетплейсов.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () =>
                          launch('https://marketplace.egorka.delivery'),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'Перейти на сайт',
                            style: CustomTextStyle.white15w600.copyWith(
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void showTipBucket(
  String text,
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 30.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () =>
                          launch('https://marketplace.egorka.delivery'),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Перейти на сайт',
                            style: CustomTextStyle.white15w600.copyWith(
                                letterSpacing: 1, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void showTipWhenTake(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 30.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Оформить заказ на завтра можно строго до 15:00 сегодняшнего дня. Далее, все заказы отправляются на планирование и внести корректировки при форс-мажоре можно только через службу поддержки.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Понятно',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void showTipWork(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 30.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Типы доставок до маркетплейса:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              )),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\n\nFBO',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' - доставка до распределительных и сортировочных центров. Тип FBO подразумевает в себе продажу со склада маркетплейса, когда вы готовите поставку, выбираете временное окно и заказываете Егорку.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\n\nFBS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' - регулярная доставка до распределительных и сортировочных центров маркетплейса. Тип FBS подразумевает в себе продажу со склада продавца, когда заказы отгружаются на ежедневной основе и доставляются Егоркой.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            text:
                                '\n\nЗаказ можно оформить на паллете или коробками россыпью. В зависимости от характеристик груза – команда Егорки назначит соответствующий авто на ваш маршрут.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () =>
                          launch('https://marketplace.egorka.delivery'),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Узнать тарифы',
                            style: CustomTextStyle.white15w600.copyWith(
                                letterSpacing: 1, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void iconSelectModal(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 50.h, left: offset.dx - 30.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: () => Navigator.of(context)
                ..pop()
                ..pop(),
              child: Container(
                width: MediaQuery.of(context).size.width - 30.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        height: 40.h,
                        alignment: Alignment.center,
                        child: Text(
                          'Обычная доставка',
                          style: CustomTextStyle.black15w700
                              .copyWith(fontSize: 15.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void iconDateOrder(
  BuildContext context,
  Offset offset,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 40.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 30.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(10.h),
                      height: 70.h,
                      alignment: Alignment.center,
                      child: Text(
                        'Курьера можно вызвать не менее, чем за 2 часа от планированного времени забора груза',
                        style: CustomTextStyle.black15w500
                            .copyWith(fontSize: 15.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
