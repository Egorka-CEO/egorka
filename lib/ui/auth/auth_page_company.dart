import 'dart:async';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthPageCompany extends StatefulWidget {
  const AuthPageCompany({super.key});

  @override
  State<AuthPageCompany> createState() => _AuthPageCompanyState();
}

class _AuthPageCompanyState extends State<AuthPageCompany> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final streamSwap = StreamController<int>();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  bool state = false;
  int index = 0;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      state = focusNode1.hasFocus;
      setState(() {});
    });
    focusNode2.addListener(() {
      state = focusNode2.hasFocus;
      setState(() {});
    });
    focusNode3.addListener(() {
      state = focusNode3.hasFocus;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSwap.close();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle =
        GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16);
    final heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
      child: StreamBuilder<int>(
          stream: streamSwap.stream,
          initialData: 0,
          builder: (context, snapshot) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 500),
              padding: EdgeInsets.symmetric(vertical: 0.h),
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        height: 610.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 80.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Войти в аккаунт',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: state ? 20.h : 36.h,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 30.h,
                            ),
                            Text(
                              'Логин компании',
                              style: labelStyle,
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    focusNode: focusNode1,
                                    textEditingController: _companyController,
                                    hintText: 'Gazprom',
                                    auth: true,
                                    height: 60.h,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 20.h,
                            ),
                            Text(
                              'Логин пользователя',
                              style: labelStyle,
                            ),
                            SizedBox(height: 5.h),
                            CustomTextField(
                              focusNode: focusNode2,
                              textEditingController: _loginController,
                              hintText: 'Admin',
                              auth: true,
                              height: 60.h,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.w,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 20.h,
                            ),
                            Text(
                              'Пароль',
                              style: labelStyle,
                            ),
                            SizedBox(height: 5.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomTextField(
                                  focusNode: focusNode3,
                                  textEditingController: _passwordController,
                                  hintText: 'Пароль',
                                  auth: true,
                                  height: 60.h,
                                  obscureText: obscureText,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.w,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obscureText = !obscureText;
                                        });
                                      },
                                      child: obscureText
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                    ),
                                    SizedBox(width: 15.w)
                                  ],
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 20.h,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () => Navigator.of(context).pushNamed(
                            //           AppRoute.registration,
                            //           arguments: false),
                            //       child: const Text(
                            //         'Егорка ещё не возит для вас?',
                            //         style: CustomTextStyle.red15,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 5.h : 20.h,
                            ),
                            // RoundedLoadingButton(
                            //   controller: _btnController,
                            //   onPressed: _signIn,
                            //   color: Colors.red,
                            //   child: const Text(
                            //     'Войти',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            CustomButton(title: 'Далее', onTap: _signIn),
                            SizedBox(height: heightKeyBoard),
                            const Spacer(flex: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _signIn() async {
    AuthUser? res;
    _btnController.start();
    res = await Repository().loginUsernameAgent(_loginController.text,
        _passwordController.text, _companyController.text);

    if (res != null) {
      await FirebaseMessaging.instance.deleteToken();
      _btnController.success();
      MySecureStorage storage = MySecureStorage();
      storage.setTypeUser('1');
      storage.setLogin(_loginController.text);
      storage.setPassword(_passwordController.text);
      storage.setCompany(_companyController.text);
      storage.setKey(res.result!.key);
      BlocProvider.of<ProfileBloc>(context).add(ProfileEventUpdate(res));
      BlocProvider.of<HistoryOrdersBloc>(context).add(GetListOrdersEvent());
      Navigator.pushNamed(context, AppRoute.home);
    } else {
      _btnController.error();
      MessageDialogs().showAlert(
          'Ошибка', 'Введен неверный логин компании/пользователя или пароль');
    }
    Future.delayed(const Duration(seconds: 1), (() {
      _btnController.reset();
    }));
  }
}
