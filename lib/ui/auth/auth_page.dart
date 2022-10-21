import 'dart:async';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // void getLocation() async {
  //   const hasPermission = Permission.locationWhenInUse;
  //   hasPermission.status.then((value) {
  //     print('object $value');
  //   });
  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // getLocation();

    return Material(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset(
                'assets/icons/logo_egorka.svg',
                height: 60,
              ),
              const Spacer(),
              CustomTextField(
                textEditingController: _loginController,
                hintText: 'Логин',
              ),
              CustomTextField(
                textEditingController: _passwordController,
                hintText: 'Пароль',
              ),
              const Spacer(),
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
    );
  }

  void _signIn(BuildContext context) async {
    _btnController.start();
    _btnController.success();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.home, (route) => false);
    });
  }
}