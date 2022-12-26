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
    return BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
        builder: (context, snapshot) {
      final blocHistory = BlocProvider.of<HistoryOrdersBloc>(context);
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
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();
                    if (auth != null) return const SizedBox();
                    return TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoute.auth),
                      style: ButtonStyle(
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.all(0)),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.red),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.grey[300])),
                      child: const Text('Авторизоваться'),
                    );
                  }),
                  // SizedBox(height: 30.h),
                  Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
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
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();
                    if (auth == null) return const SizedBox();
                    return GestureDetector(
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
                    );
                  }),
                  if (blocHistory.coast.isNotEmpty)
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoute.currentOrder,
                          arguments: blocHistory.coast.first),
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
