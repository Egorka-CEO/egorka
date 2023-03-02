import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<ProfileBloc>(context).getUser();
    BlocProvider.of<ProfileBloc>(context).add(GetDepositeEvent());

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Профиль',
            style: CustomTextStyle.black17w400,
          ),
          foregroundColor: Colors.red,
          elevation: 0.5,
        ),
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
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20.h),
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
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if ((auth != null &&
                                        auth.result!.agent != null))
                                      Column(
                                        children: [
                                          Text(
                                            auth.result!.agent!.Title!,
                                            style: CustomTextStyle.black15w700
                                                .copyWith(fontSize: 17),
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                    Text(
                                      'Депозит:',
                                      style: CustomTextStyle.black15w700
                                          .copyWith(fontSize: 24),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Text(
                                          cash,
                                          style: CustomTextStyle.black15w700
                                              .copyWith(
                                            fontSize: 30,
                                            color: Colors.green[600],
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context,
                                                AppRoute.trafficDeposit);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: const [
                          Text(
                            'Основные данные',
                            style: CustomTextStyle.black17w400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Container(
                        padding: EdgeInsets.all(20.0.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Имя: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.result!.user!.name ?? '-',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Логин: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            user.result!.user!.username ?? '-',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Моб. номер: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.result!.user!.phoneMobile ??
                                            '-',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Раб. номер: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.result!.user!.phoneOffice ??
                                            '-',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Email: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: user.result!.user!.email ?? '-',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Временная зона: ',
                                        style: CustomTextStyle.black15w700
                                            .copyWith(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const TextSpan(
                                        text: 'Europe/Moscow',
                                        style: CustomTextStyle.black15w700,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: const [
                          Text(
                            'Пароль',
                            style: CustomTextStyle.black17w400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Новый пароль: ',
                                  style: CustomTextStyle.black15w700.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  height: 45.h,
                                  child: Stack(
                                    children: [
                                      CustomTextField(
                                        height: 45.h,
                                        obscureText:
                                            newPassword1PasswordVisible,
                                        focusNode: password2Focus,
                                        hintText: '',
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        fillColor: backgroundColor,
                                        textEditingController: newPassword1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 15.w),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  newPassword1PasswordVisible =
                                                      !newPassword1PasswordVisible;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  !newPassword1PasswordVisible
                                                      ? Icon(Icons.visibility,
                                                          color:
                                                              Colors.grey[500])
                                                      : Icon(
                                                          Icons.visibility_off,
                                                          color:
                                                              Colors.grey[500]),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Новый пароль повторно: ',
                                  style: CustomTextStyle.black15w700.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  height: 45.h,
                                  child: Stack(
                                    children: [
                                      CustomTextField(
                                        height: 45.h,
                                        focusNode: password3Focus,
                                        obscureText:
                                            newPassword2PasswordVisible,
                                        hintText: '',
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        fillColor: backgroundColor,
                                        textEditingController: newPassword2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 15.w),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  newPassword2PasswordVisible =
                                                      !newPassword2PasswordVisible;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  !newPassword2PasswordVisible
                                                      ? Icon(Icons.visibility,
                                                          color:
                                                              Colors.grey[500])
                                                      : Icon(
                                                          Icons.visibility_off,
                                                          color:
                                                              Colors.grey[500]),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (newPassword1.text.isNotEmpty ||
                        newPassword2.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: SizedBox(
                          height: 60.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              if ((newPassword1.text == newPassword2.text) &&
                                  newPassword1.text.isNotEmpty &&
                                  newPassword2.text.isNotEmpty) {
                                final storage = MySecureStorage();
                                final type = await storage.getTypeUser();
                                if (type == '0') {
                                  final res = await Repository()
                                      .updateProfileUser(newPassword1.text);
                                  if (res) {
                                    MessageDialogs().completeDialog(
                                        text: 'Пароль успешно изменен');
                                  }
                                } else {
                                  final res = await Repository()
                                      .updateProfileAgent(newPassword1.text);
                                  if (res) {
                                    MySecureStorage storage = MySecureStorage();
                                    storage.setPassword(newPassword1.text);
                                    MessageDialogs().completeDialog(
                                        text: 'Пароль успешно изменен');
                                  }
                                }
                              } else {
                                if (newPassword1.text.isEmpty) {
                                  MessageDialogs().showAlert(
                                      'Ошибка', 'Введите новый пароль');
                                } else if (newPassword2.text.isEmpty) {
                                  MessageDialogs().showAlert(
                                      'Ошибка', 'Введите новый пароль еще раз');
                                } else if (newPassword1.text !=
                                    newPassword2.text) {
                                  MessageDialogs().showAlert(
                                      'Ошибка', 'Пароли не совпадают');
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                            child: Text(
                              'Обновить пароль',
                              style:
                                  TextStyle(fontSize: 17.sp, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: SizedBox(
                        height: 60.h,
                        child: ElevatedButton(
                          onPressed: () => BlocProvider.of<ProfileBloc>(context)
                              .add(ExitAccountEvent()),
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          child: Text(
                            'ВЫХОД',
                            style: TextStyle(fontSize: 17.sp, letterSpacing: 1),
                          ),
                        ),
                      ),
                    )
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
