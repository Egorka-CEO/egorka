import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/type_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget tabGroup(
  TabController tabController,
  int indexTab,
  TypeGroup typeGroup,
  Function(int) function,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13.r),
      color: Colors.white,
    ),
    child: TabBar(
      unselectedLabelColor: Colors.black,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.red,
      ),
      onTap: (value) {
        function(value);
      },
      splashBorderRadius: BorderRadius.circular(20),
      controller: tabController,
      tabs: [
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'FBO',
              style: CustomTextStyle.grey15bold.copyWith(
                  fontSize: 14.sp,
                  color: indexTab == 0 ? Colors.white : Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'FBS',
              style: CustomTextStyle.grey15bold.copyWith(
                  fontSize: 14.sp,
                  color: indexTab == 1 ? Colors.white : Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Сборный FBS',
              textAlign: TextAlign.center,
              style: CustomTextStyle.grey15bold.copyWith(
                  fontSize: 14.sp,
                  color: indexTab == 2 ? Colors.white : Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}
