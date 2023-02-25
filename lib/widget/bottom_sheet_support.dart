import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SupportMessageBtmSheet extends StatelessWidget {
  PanelController panelController;
  SupportMessageBtmSheet(this.panelController, {super.key});

  @override
  Widget build(BuildContext context) {
    String? name =
        BlocProvider.of<ProfileBloc>(context).getUser()?.result?.user?.name;
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GestureDetector(
                          onTap: () {
                            panelController.close();
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: SizedBox(
                    height: 200.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5.r,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: SvgPicture.asset(
                              'assets/icons/logo_egorka.svg',
                              height: 35.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Text(
                            'Здравствуйте, ${name ?? 'Пользователь'}',
                            style: CustomTextStyle.white15w600
                                .copyWith(fontSize: 23.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 200.h),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 220.h,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text('asdasdad'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
