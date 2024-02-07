import 'package:egorka/helpers/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: Material(
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   title: const Text(
          //     'О приложении',
          //     style: CustomTextStyle.black17w400,
          //   ),
          //   foregroundColor: Colors.red,
          //   elevation: 0.5,
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: EdgeInsets.only(top: 76.h),
                  child: Row(
                    children: [
                      SizedBox(width: 20.w),
                      SvgPicture.asset(
                        'assets/icons/arrow-left.svg',
                        width: 30.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Назад',
                        style: GoogleFonts.manrope(
                          fontSize: 17.h,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // SizedBox(height: 100.h),
              Image.asset(
                'assets/images/egorka_circle.png',
                height: 150.h,
              ),
              const Spacer(flex: 1),
              SvgPicture.asset(
                'assets/icons/logo_egorka.svg',
                height: 60.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Версия: $_version',
                style: GoogleFonts.manrope(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 22),
            ],
          ),
        ),
      ),
    );
  }
}
