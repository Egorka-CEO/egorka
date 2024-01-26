import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/helpers/app_colors.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FocusNode password1Focus = FocusNode();

  final FocusNode password2Focus = FocusNode();

  final FocusNode password3Focus = FocusNode();

  TextEditingController newPassword1 = TextEditingController();

  TextEditingController newPassword2 = TextEditingController();

  bool newPassword1PasswordVisible = true;
  bool newPassword2PasswordVisible = true;

  bool notificationValue = true;

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<ProfileBloc>(context).getUser();
    BlocProvider.of<ProfileBloc>(context).add(GetDepositEvent());

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: Scaffold(
        backgroundColor: AppConsts.backgroundColor,
        body: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) {
          if (current is ExitStated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
          }
          return false;
        }, builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  // physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
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
                    SizedBox(height: 32.h),
                    Container(
                      height: 190.h,
                      width: 190.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/egorka_man.png',
                        height: 130.h,
                      ),
                    ),
                    if (user!.result!.agent != null)
                      BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, snapshot) {
                        final auth =
                            BlocProvider.of<ProfileBloc>(context).getUser();
                        String cash = '0 ₽';
                        if (snapshot is UpdateDeposit) {
                          cash = '${(snapshot.accounts.amount / 100).ceil()}';
                          cash = cash.replaceAllMapped(
                              RegExp(r"(\d)(?=(\d{3})+(?!\d))"),
                              (match) => "${match.group(0)} ");
                          cash += ' ₽';
                        }
                        return Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if ((user.result != null &&
                                  user.result!.user!.name! != null))
                                Column(
                                  children: [
                                    Text(
                                      ('${user.result!.user!.name!} ${user.result!.user!.patronymic!}') ??
                                          '',
                                      style: GoogleFonts.manrope(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              if ((auth != null && auth.result!.agent != null))
                                Column(
                                  children: [
                                    Text(
                                      (auth.result?.agent?.title) ?? '',
                                      style: GoogleFonts.manrope(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                            177, 177, 177, 1),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 64.h,
                                      width: 320.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: AppColors.grey,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Депозит:',
                                            style: GoogleFonts.manrope(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            cash,
                                            style: GoogleFonts.manrope(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRoute.trafficDeposit);
                                    },
                                    child: Container(
                                      height: 64.h,
                                      width: 64.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: AppColors.grey,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Color.fromRGBO(52, 199, 89, 1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    SizedBox(height: 20.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Row(
                    //     children: const [
                    //       Text(
                    //         'Основные данные',
                    //         style: CustomTextStyle.black17w400,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Container(
                    //     padding: EdgeInsets.all(20.0.w),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.r),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Имя: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: user.result!.user!.name ?? '-',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: 15.h),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Логин: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text:
                    //                         user.result!.user!.username ?? '-',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: 15.h),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Моб. номер: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: user.result!.user!.phoneMobile ??
                    //                         '-',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: 15.h),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Раб. номер: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: user.result!.user!.phoneOffice ??
                    //                         '-',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: 15.h),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Email: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: user.result!.user!.email ?? '-',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: 15.h),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Временная зона: ',
                    //                     style: CustomTextStyle.black15w700
                    //                         .copyWith(
                    //                       color: Colors.grey[700],
                    //                     ),
                    //                   ),
                    //                   const TextSpan(
                    //                     text: 'Europe/Moscow',
                    //                     style: CustomTextStyle.black15w700,
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Row(
                    //     children: const [
                    //       Text(
                    //         'Пароль',
                    //         style: CustomTextStyle.black17w400,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Container(
                    //     padding: EdgeInsets.all(20.w),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20.r),
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Новый пароль: ',
                    //               style: CustomTextStyle.black15w700.copyWith(
                    //                 color: Colors.grey[700],
                    //               ),
                    //             ),
                    //             SizedBox(height: 5.h),
                    //             SizedBox(
                    //               height: 45.h,
                    //               child: Stack(
                    //                 children: [
                    //                   CustomTextField(
                    //                     height: 45.h,
                    //                     obscureText:
                    //                         newPassword1PasswordVisible,
                    //                     focusNode: password2Focus,
                    //                     hintText: '',
                    //                     onChanged: (value) {
                    //                       setState(() {});
                    //                     },
                    //                     fillColor: backgroundColor,
                    //                     textEditingController: newPassword1,
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(right: 15.w),
                    //                     child: Align(
                    //                         alignment: Alignment.centerRight,
                    //                         child: GestureDetector(
                    //                           onTap: () {
                    //                             setState(() {
                    //                               newPassword1PasswordVisible =
                    //                                   !newPassword1PasswordVisible;
                    //                             });
                    //                           },
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               !newPassword1PasswordVisible
                    //                                   ? Icon(Icons.visibility,
                    //                                       color:
                    //                                           Colors.grey[500])
                    //                                   : Icon(
                    //                                       Icons.visibility_off,
                    //                                       color:
                    //                                           Colors.grey[500]),
                    //                             ],
                    //                           ),
                    //                         )),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 15.h),
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Новый пароль повторно: ',
                    //               style: CustomTextStyle.black15w700.copyWith(
                    //                 color: Colors.grey[700],
                    //               ),
                    //             ),
                    //             SizedBox(height: 5.h),
                    //             SizedBox(
                    //               height: 45.h,
                    //               child: Stack(
                    //                 children: [
                    //                   CustomTextField(
                    //                     height: 45.h,
                    //                     focusNode: password3Focus,
                    //                     obscureText:
                    //                         newPassword2PasswordVisible,
                    //                     hintText: '',
                    //                     onChanged: (value) {
                    //                       setState(() {});
                    //                     },
                    //                     fillColor: backgroundColor,
                    //                     textEditingController: newPassword2,
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(right: 15.w),
                    //                     child: Align(
                    //                         alignment: Alignment.centerRight,
                    //                         child: GestureDetector(
                    //                           onTap: () {
                    //                             setState(() {
                    //                               newPassword2PasswordVisible =
                    //                                   !newPassword2PasswordVisible;
                    //                             });
                    //                           },
                    //                           child: Row(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.end,
                    //                             children: [
                    //                               !newPassword2PasswordVisible
                    //                                   ? Icon(Icons.visibility,
                    //                                       color:
                    //                                           Colors.grey[500])
                    //                                   : Icon(
                    //                                       Icons.visibility_off,
                    //                                       color:
                    //                                           Colors.grey[500]),
                    //                             ],
                    //                           ),
                    //                         )),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20.h),
                    // if (newPassword1.text.isNotEmpty ||
                    //     newPassword2.text.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //     child: SizedBox(
                    //       height: 60.h,
                    //       child: ElevatedButton(
                    //         onPressed: () async {
                    //           if ((newPassword1.text == newPassword2.text) &&
                    //               newPassword1.text.isNotEmpty &&
                    //               newPassword2.text.isNotEmpty) {
                    //             final storage = MySecureStorage();
                    //             final type = await storage.getTypeUser();
                    //             if (type == '0') {
                    //               final res = await Repository()
                    //                   .updateProfileUser(newPassword1.text);
                    //               if (res) {
                    //                 MessageDialogs().completeDialog(
                    //                     text: 'Пароль успешно изменен');
                    //               }
                    //             } else {
                    //               final res = await Repository()
                    //                   .updateProfileAgent(newPassword1.text);
                    //               if (res) {
                    //                 MySecureStorage storage = MySecureStorage();
                    //                 storage.setPassword(newPassword1.text);
                    //                 MessageDialogs().completeDialog(
                    //                     text: 'Пароль успешно изменен');
                    //               }
                    //             }
                    //           } else {
                    //             if (newPassword1.text.isEmpty) {
                    //               MessageDialogs().showAlert(
                    //                   'Ошибка', 'Введите новый пароль');
                    //             } else if (newPassword2.text.isEmpty) {
                    //               MessageDialogs().showAlert(
                    //                   'Ошибка', 'Введите новый пароль еще раз');
                    //             } else if (newPassword1.text !=
                    //                 newPassword2.text) {
                    //               MessageDialogs().showAlert(
                    //                   'Ошибка', 'Пароли не совпадают');
                    //             }
                    //           }
                    //         },
                    //         style: ButtonStyle(
                    //           backgroundColor:
                    //               const MaterialStatePropertyAll(Colors.red),
                    //           shape: MaterialStateProperty.all<
                    //               RoundedRectangleBorder>(
                    //             RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10.r),
                    //             ),
                    //           ),
                    //         ),
                    //         child: Text(
                    //           'Обновить пароль',
                    //           style:
                    //               TextStyle(fontSize: 17.sp, letterSpacing: 1),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // SizedBox(height: 20.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: SizedBox(
                    //     height: 60.h,
                    //     child: ElevatedButton(
                    //       onPressed: () async {
                    //         await FirebaseMessaging.instance.deleteToken();

                    //         BlocProvider.of<ProfileBloc>(context)
                    //             .add(ExitAccountEvent());
                    //       },
                    //       style: ButtonStyle(
                    //         backgroundColor:
                    //             const MaterialStatePropertyAll(Colors.red),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10.r),
                    //           ),
                    //         ),
                    //       ),
                    //       child: Text(
                    //         'ВЫХОД',
                    //         style: TextStyle(fontSize: 17.sp, letterSpacing: 1),
                    //       ),
                    //     ),
                    //   ),
                    // )
                    // CustomButton(
                    //   title: 'Выйти из аккаунта',
                    //   onTap: () async {
                    //     await FirebaseMessaging.instance.deleteToken();

                    //     BlocProvider.of<ProfileBloc>(context)
                    //         .add(ExitAccountEvent());
                    //   },
                    // ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            'Уведомления',
                            style: GoogleFonts.manrope(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Switch.adaptive(
                            value: notificationValue,
                            onChanged: (value) {
                              setState(() {
                                notificationValue = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoute.about),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              'О приложении',
                              style: GoogleFonts.manrope(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            RotatedBox(
                              quarterTurns: 90,
                              child: SvgPicture.asset(
                                'assets/icons/arrow-left.svg',
                              ),
                            ),
                            SizedBox(width: 20.w),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseMessaging.instance.deleteToken();

                        BlocProvider.of<ProfileBloc>(context)
                            .add(ExitAccountEvent());
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              'Выйти из аккаунта',
                              style: GoogleFonts.manrope(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(255, 102, 102, 1),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            SvgPicture.asset('assets/icons/logout.svg'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
