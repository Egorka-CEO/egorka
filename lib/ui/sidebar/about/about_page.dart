import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'О приложении',
              style: CustomTextStyle.black17w400,
            ),
            foregroundColor: Colors.red,
            elevation: 0.5,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                SvgPicture.asset(
                  'assets/icons/logo_egorka.svg',
                  height: 60.h,
                ),
                SizedBox(height: 20.h),
                const Text('Версия 0.1', style: CustomTextStyle.black17w400),
                const Spacer(flex: 20),
                const Text('Команда разработки',
                    style: CustomTextStyle.black17w400),
                SizedBox(height: 10.h),
                Image.asset(
                  'assets/images/ic_broseph.png',
                  height: 150.h,
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
