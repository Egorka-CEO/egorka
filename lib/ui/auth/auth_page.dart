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

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
    final heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    TextStyle labelStyle =
        GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
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
                        height: 505.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 20.h : 80.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Войти в аккаунт',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36.h,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            // SizedBox(height: 10.h),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       'Егорка готов! Входите и начнём',
                            //       style: TextStyle(fontSize: 23.sp),
                            //     ),
                            //   ],
                            // ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuint,
                              height: state ? 20.h : 30.h,
                            ),
                            Text(
                              'Логин',
                              style: labelStyle,
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    focusNode: focusNode1,
                                    textEditingController: _phoneController,
                                    hintText: 'Arcadi',
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
                                  obscureText: obscureText,
                                  height: 60.h,
                                  auth: true,
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
                            //           arguments: true),
                            //       child: const Text(
                            //         'Егорка ещё не возит для вас?',
                            //         style: CustomTextStyle.red15,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: state ? 20.h : 20.h,
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
    res = await Repository()
        .loginUsernameUser(_phoneController.text, _passwordController.text);

    if (res != null) {
      await FirebaseMessaging.instance.deleteToken();
      _btnController.success();
      MySecureStorage storage = MySecureStorage();
      storage.setTypeUser('0');
      storage.setLogin(_phoneController.text);
      storage.setPassword(_passwordController.text);
      storage.setKey(res.result!.key);
      BlocProvider.of<ProfileBloc>(context).add(ProfileEventUpdate(res));
      BlocProvider.of<HistoryOrdersBloc>(context).add(GetListOrdersEvent());
      // Navigator.of(context).pop(res);
      Navigator.pushNamed(context, AppRoute.home);
    } else {
      _btnController.error();
      MessageDialogs().showAlert('Ошибка', 'Введен неверный логин или пароль');
    }
    Future.delayed(const Duration(seconds: 1), (() {
      _btnController.reset();
    }));
  }
}
