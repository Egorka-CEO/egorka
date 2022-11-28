import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, snapshot) {
      return SizedBox(
        width: 270.w,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(color: Colors.white),
            Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
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
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoute.trafficDeposit),
                            child: Text(
                              'Движение по депозиту',
                              style: CustomTextStyle.black15w500
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoute.addDeposit),
                            child: Icon(
                              Icons.add,
                              color: Colors.red.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (bloc.getUser() != null)
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoute.profile),
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Профиль',
                            style: CustomTextStyle.black15w500
                                .copyWith(color: Colors.black),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Текущий заказ',
                          style: CustomTextStyle.black15w500
                              .copyWith(color: Colors.black),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'История заказов',
                          style: CustomTextStyle.black15w500
                              .copyWith(color: Colors.black),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Маркетплейсы',
                          style: CustomTextStyle.black15w500
                              .copyWith(color: Colors.black),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Записная книжка',
                          style: CustomTextStyle.black15w500
                              .copyWith(color: Colors.black),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'О приложении',
                          style: CustomTextStyle.black15w500
                              .copyWith(color: Colors.black),
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
    });
  }
}
