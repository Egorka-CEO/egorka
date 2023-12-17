import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Disconnected extends StatelessWidget {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/anim/disconnect.json'),
            Text(
              'Соединение с интернетом потеряно',
              style: CustomTextStyle.black15w700.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                title: 'Повторить попытку',
                onTap: () async {
                  final res = await DataConnectionChecker().connectionStatus;
                  if (res.name == 'disconnected') {
                    _btnController.error();
                  } else {
                    _btnController.success();
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop();
                    });
                  }
                  Future.delayed(const Duration(seconds: 1), () {
                    _btnController.reset();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
