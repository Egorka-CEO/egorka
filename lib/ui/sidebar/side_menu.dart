import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blur/blur.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.w,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Blur(
            blur: 100,
            blurColor: Colors.white,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 250,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: ListView(
              children: [
                SvgPicture.asset(
                  'assets/icons/logo_egorka.svg',
                  alignment: Alignment.center,
                  width: 100.w,
                  height: 40.w,
                ),
                SizedBox(height: 30.h),
                Container(
                  color: Colors.transparent,
                  height: 50.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoute.trafficDeposit),
                          child: Text(
                            'Движение по депозиту',
                            style: CustomTextStyle.black15w500
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoute.addDeposit),
                          child: Icon(
                            Icons.add,
                            color: Colors.red.withOpacity(0.6),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.profile),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Профиль',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.currentOrder),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Текущий заказ',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<HistoryOrdersBloc>(context)
                        .add(OpenBtmSheetHistoryEvent());
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'История заказов',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.marketplaces),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Маркетплейсы',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.book),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Записная книжка',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.about),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'О приложении',
                        style: CustomTextStyle.black15w500
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
