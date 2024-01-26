import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalPriceWidget extends StatelessWidget {
  String title;
  String icon;
  String totalPrice;
  String? comissionPaymentSystem;
  String? additionalCost;
  String? deliveryCost;
  VoidCallback onTap;

  TotalPriceWidget({super.key,
    required this.title,
    required this.icon,
    required this.totalPrice,
    this.comissionPaymentSystem,
    this.additionalCost,
    this.deliveryCost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200.h,
          padding: EdgeInsets.only(bottom: 10.h),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.r),
              topLeft: Radius.circular(15.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 20.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        icon,
                        color: Colors.red,
                        height: 80.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '$totalPrice ₽',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Center(
                        child: Text(
                          '}',
                          style: TextStyle(
                            height: 1,
                            fontSize: 60,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${deliveryCost ?? 0} ₽ доставка',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${additionalCost ?? 0} ₽ доп. услуги',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '+${comissionPaymentSystem ?? 0} ₽ при оплате картой',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'ОФОРМИТЬ ЗАКАЗ',
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
  }
}
