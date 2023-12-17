import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/widget/policy_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  MySecureStorage storage = MySecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
          builder: (context, snapshot) {
        final blocHistory = BlocProvider.of<HistoryOrdersBloc>(context);
        CreateFormModel? createFormModel;

        for (var element in blocHistory.coast) {
          if (element.result.Status == 'Booked' &&
              element.result.StatusPay != 'Paid') {
            createFormModel = element;
            break;
          }
        }

        return SizedBox(
          width: 270.w,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(color: Colors.white),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: SvgPicture.asset(
                      'assets/icons/logo_egorka.svg',
                      alignment: Alignment.center,
                      width: 100.w,
                      height: 40.w,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, snapshot) {
                      final auth =
                          BlocProvider.of<ProfileBloc>(context).getUser();
                      if (auth != null) return const SizedBox();
                      return SizedBox(
                        width: 270.w,
                        height: 50.h,
                        child: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AppRoute.mainAuth),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.only(left: 18)),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.red[700])),
                          child: const Text('Входите, и начём'),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();
                    if (auth == null || auth.result!.agent == null) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Container(
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
                                  'Депозит',
                                  style: CustomTextStyle.black17w400
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();

                    if (auth == null ||
                        auth.result!.agent == null ||
                        auth.result!.user == null ||
                        auth.result!.user!.username != 'Admin') {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoute.employee),
                                child: Text(
                                  'Мои сотрудники',
                                  style: CustomTextStyle.black17w400
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();
                    if (auth == null) return const SizedBox();
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoute.profile),
                        child: Container(
                          color: Colors.transparent,
                          height: 50.h,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Профиль',
                              style: CustomTextStyle.black17w400
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // if (createFormModel != null)
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 18.w),
                  //   child: GestureDetector(
                  //     onTap: () => Navigator.pushNamed(
                  //       context,
                  //       AppRoute.mixFBS,
                  //       arguments: [
                  //         null, null,
                  //         // createFormModel!.result.RecordNumber,
                  //         // createFormModel.result.RecordPIN
                  //       ],
                  //     ),
                  //     child: Container(
                  //       color: Colors.transparent,
                  //       height: 50.h,
                  //       child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           'Сборный груз',
                  //           style: CustomTextStyle.black17w400
                  //               .copyWith(color: Colors.black),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: GestureDetector(
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
                            style: CustomTextStyle.black17w400
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, AppRoute.marketplaces);
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Маркетплейсы',
                            style: CustomTextStyle.black17w400
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, snapshot) {
                    final auth =
                        BlocProvider.of<ProfileBloc>(context).getUser();
                    if (auth == null) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoute.book),
                        child: Container(
                          color: Colors.transparent,
                          height: 50.h,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Записная книжка',
                              style: CustomTextStyle.black17w400
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: GestureDetector(
                      onTap: () =>
                          launch('https://marketplace.egorka.delivery'),
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Тарифы',
                            style: CustomTextStyle.black17w400
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoute.about),
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'О приложении',
                            style: CustomTextStyle.black17w400
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launch(
                              'https://egorka.delivery/egorka_rules.pdf',
                            );
                          },
                          child: Text(
                            'Договор оферты',
                            style: CustomTextStyle.grey14w400
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) {
                                  return PolicyView();
                                }),
                              ),
                            );
                          },
                          child: Text(
                            'Политика конфиденциальности',
                            style: CustomTextStyle.grey14w400
                                .copyWith(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                    // child: RichText(
                    //   // textAlign: TextAlign.justify,
                    //   text: TextSpan(
                    //     children: [
                    //       // TextSpan(
                    //       //   text:
                    //       //       'Нажимаю кнопку «Начать работать» Вы соглашаетесь с ',
                    //       //   style: CustomTextStyle.black17w400
                    //       //       .copyWith(fontSize: 13.sp),
                    //       // ),
                    //       TextSpan(
                    //         recognizer: TapGestureRecognizer()
                    //           ..onTap = () => launch(
                    //               'https://egorka.delivery/egorka_rules.pdf'),
                    //         text: 'Договор оферты',
                    //         style:
                    //             CustomTextStyle.red15.copyWith(fontSize: 13.sp),
                    //       ),
                    // TextSpan(
                    //   text: 'и ',
                    //   style: CustomTextStyle.black17w400
                    //       .copyWith(fontSize: 13.sp),
                    // ),
                    // TextSpan(
                    //   recognizer: TapGestureRecognizer()
                    //     ..onTap = () => Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: ((context) {
                    //               return PolicyView();
                    //             }),
                    //           ),
                    //         ),
                    //   text: '\nПолитика конфиденциальности',
                    //   style:
                    //       CustomTextStyle.red15.copyWith(fontSize: 13.sp),
                    // ),
                    // TextSpan(
                    //   text: ' ООО «Егорка»',
                    //   style: CustomTextStyle.black17w400
                    //       .copyWith(fontSize: 13.sp),
                    // ),
                    // ],
                    // ),
                    // ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
