import 'dart:async';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

enum TypeLogin { Username, Email, Phone }

class AuthPage extends StatefulWidget {
  TypeSignIn typeSignIn;
  AuthPage({
    required this.typeSignIn,
    super.key,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _loginController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _companyController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final streamSwap = StreamController<int>();
  late TypeLogin logType;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  bool state = true;
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
    focusNode1.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    streamSwap.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: streamSwap.stream,
        initialData: 0,
        builder: (context, snapshot) {
          logType = TypeLogin.values[snapshot.data!];
          String hint = '';
          switch (logType) {
            case TypeLogin.Username:
              hint = 'Никнейм';
              break;
            case TypeLogin.Email:
              hint = 'Email';
              break;
            case TypeLogin.Phone:
              hint = 'Телефон';
              break;
            default:
          }
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: state ? 10.h : 100.h),
            child: Material(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/logo_egorka.svg',
                        height: 60.h,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 20.h : 30.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              focusNode: focusNode1,
                              textEditingController: _loginController,
                              hintText: hint,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.w,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _loginController.text = '';
                              int index = snapshot.data!;
                              if (index == 2)
                                index = 0;
                              else
                                ++index;
                              this.index = index;
                              streamSwap.add(index);
                            },
                            child: Icon(Icons.swap_horiz_sharp),
                          )
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 10.h : 20.h,
                      ),
                      CustomTextField(
                        focusNode: focusNode2,
                        textEditingController: _passwordController,
                        hintText: 'Пароль',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.w,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: state ? 10.h : 20.h,
                      ),
                      if (widget.typeSignIn == TypeSignIn.Company)
                        Column(
                          children: [
                            CustomTextField(
                              focusNode: focusNode3,
                              textEditingController: _companyController,
                              hintText: 'Компания',
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
                        onPressed: () => _signIn(context),
                        color: Colors.black,
                        child: const Text(
                          'Войти',
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

  void _signIn(BuildContext context) async {
    late bool res;
    _btnController.start();
    if (widget.typeSignIn == TypeSignIn.Company) {
      if (_loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _companyController.text.isNotEmpty) {
        switch (logType) {
          case TypeLogin.Username:
            res = await Repository().loginUsernameAgent(_loginController.text,
                _passwordController.text, _companyController.text);
            break;
          case TypeLogin.Email:
            res = await Repository().loginEmailAgent(_loginController.text,
                _passwordController.text, _companyController.text);
            break;
          case TypeLogin.Phone:
            res = await Repository().loginPhoneAgent(_loginController.text,
                _passwordController.text, _companyController.text);
            break;
          default:
            res = false;
        }
      }
    } else {
      if (_loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        switch (logType) {
          case TypeLogin.Username:
            res = await Repository().loginUsernameUser(
                _loginController.text, _passwordController.text);
            break;
          case TypeLogin.Email:
            res = await Repository().loginEmailUser(
                _loginController.text, _passwordController.text);
            break;
          case TypeLogin.Phone:
            res = await Repository().loginPhoneUser(
                _loginController.text, _passwordController.text);
            break;
          default:
            res = false;
        }
      }
    }
    if (res) {
      _btnController.success();
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pushNamed(AppRoute.newOrder);
    } else {
      _btnController.error();
    }
    Future.delayed(const Duration(seconds: 1), (() {
      _btnController.reset();
    }));
  }
}
