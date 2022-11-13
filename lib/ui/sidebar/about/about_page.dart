import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            size: 30.h,
                            color: Colors.red,
                          ),
                        ),
                        const Align(
                          child: Text('О приложении',
                              style: CustomTextStyle.black15w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            SvgPicture.asset(
              'assets/icons/logo_egorka.svg',
              height: 60.h,
            ),
            SizedBox(height: 20.h),
            const Text('Version 0.1', style: CustomTextStyle.black15w500),
            const Spacer(flex: 20),
            const Text('Команда разработки',
                style: CustomTextStyle.black15w500),
            SizedBox(height: 10.h),
            Image.asset(
              'assets/images/ic_broseph.png',
              height: 20.h,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
