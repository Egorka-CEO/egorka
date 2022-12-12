import 'dart:async';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthPageCompany extends StatefulWidget {
  AuthPageCompany({super.key});

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
    // focusNode1.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    streamSwap.close();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle =
        const TextStyle(fontWeight: FontWeight.w300, fontSize: 16);
    return StreamBuilder<int>(
        stream: streamSwap.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Material(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 20.h : 80.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              'assets/icons/logo_egorka.svg',
                              height: 60.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Егорка готов! Входите и начнём',
                            style: TextStyle(fontSize: 23.sp),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 20.h : 30.h,
                      ),
                      Text(
                        'Логин компании',
                        style: labelStyle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              focusNode: focusNode1,
                              textEditingController: _companyController,
                              hintText: 'Gazprom',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 10.h : 20.h,
                      ),
                      Text(
                        'Логин пользователя',
                        style: labelStyle,
                      ),
                      CustomTextField(
                        focusNode: focusNode2,
                        textEditingController: _loginController,
                        hintText: 'Admin',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.w,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 10.h : 20.h,
                      ),
                      Text(
                        'Пароль',
                        style: labelStyle,
                      ),
                      Column(
                        children: [
                          CustomTextField(
                            focusNode: focusNode3,
                            textEditingController: _passwordController,
                            hintText: '******',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.w,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: state ? 10.h : 20.h,
                          ),
                        ],
                      ),
                      RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: _signIn,
                        color: Colors.red,
                        child: const Text(
                          'Авторизация',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(flex: 4),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _signIn() async {
    AuthUser? res;
    _btnController.start();
    if (_companyController.text.isNotEmpty) {
      res = await Repository().loginUsernameAgent(_loginController.text,
          _passwordController.text, _companyController.text);
    }
    if (res != null) {
      _btnController.success();
      MySecureStorage storage = MySecureStorage();
      storage.setLogin(_loginController.text);
      storage.setPassword(_passwordController.text);
      storage.setCompany(
          _companyController.text.isEmpty ? null : _companyController.text);
      Navigator.of(context).pop(res);
    } else {
      _btnController.error();
    }
    Future.delayed(const Duration(seconds: 1), (() {
      _btnController.reset();
    }));
  }
}
