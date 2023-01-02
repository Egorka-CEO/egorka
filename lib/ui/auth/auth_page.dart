import 'dart:async';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

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
    final heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
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
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      height: 500.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: state ? 5.h : 80.h,
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
                            height: state ? 5.h : 30.h,
                          ),
                          Text(
                            'Логин',
                            style: labelStyle,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode1,
                                  textEditingController: _phoneController,
                                  hintText: 'Arcadi',
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
                            duration: const Duration(milliseconds: 200),
                            height: state ? 5.h : 20.h,
                          ),
                          Text(
                            'Пароль',
                            style: labelStyle,
                          ),
                          CustomTextField(
                            focusNode: focusNode3,
                            textEditingController: _passwordController,
                            hintText: '******',
                            height: 60.h,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.w,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: state ? 5.h : 20.h,
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
        });
  }

  void _signIn() async {
    AuthUser? res;
    _btnController.start();
    res = await Repository()
        .loginPhoneUser(_phoneController.text, _passwordController.text);
    if (res != null) {
      _btnController.success();
      MySecureStorage storage = MySecureStorage();
      storage.setTypeUser('0');
      storage.setLogin(_phoneController.text);
      storage.setPassword(_passwordController.text);
      BlocProvider.of<ProfileBloc>(context).add(ProfileEventUpdate(res));
      Navigator.of(context).pop(res);
    } else {
      _btnController.error();
    }
    Future.delayed(const Duration(seconds: 1), (() {
      _btnController.reset();
    }));
  }
}

class CustomInputFormatter extends TextInputFormatter {
  // +7 (___) ___-__-__
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.text.length > oldValue.text.length) {
      if (newValue.text[0] == '7') {
        return newValue.copyWith(
            text: '+7 (', selection: const TextSelection.collapsed(offset: 4));
      }
      if (newValue.selection.baseOffset == 2) {
        return newValue.copyWith(
            text: '${newValue.text} (',
            selection:
                TextSelection.collapsed(offset: newValue.text.length + 2));
      }
      if (newValue.selection.baseOffset == 7) {
        return newValue.copyWith(
            text: '${newValue.text}) ',
            selection:
                TextSelection.collapsed(offset: newValue.text.length + 2));
      }
      if (newValue.selection.baseOffset == 12) {
        return newValue.copyWith(
            text: '${newValue.text}-',
            selection:
                TextSelection.collapsed(offset: newValue.text.length + 1));
      }
      if (newValue.selection.baseOffset == 15) {
        return newValue.copyWith(
            text: '${newValue.text}-',
            selection:
                TextSelection.collapsed(offset: newValue.text.length + 1));
      }
    }

    return newValue.copyWith(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
