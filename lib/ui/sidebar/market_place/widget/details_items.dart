import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget detailsItems(
  bool? data,
  TextEditingController item1Controller,
  TextEditingController item2Controller,
  TextEditingController item3Controller,
  FocusNode podFocus,
  FocusNode etajFocus,
  FocusNode officeFocus,
) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    height: data! ? 85.h : 0.h,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                Text(
                  'Не обязательно к заполнению',
                  style: CustomTextStyle.grey15bold
                      .copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    height: 45.h,
                    focusNode: podFocus,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    hintText: 'Подъезд',
                    textInputType: TextInputType.number,
                    textEditingController: item1Controller,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomTextField(
                    height: 45.h,
                    focusNode: etajFocus,
                    fillColor: Colors.white,
                    hintText: 'Этаж',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    textInputType: TextInputType.number,
                    textEditingController: item2Controller,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomTextField(
                    height: 45.h,
                    focusNode: officeFocus,
                    fillColor: Colors.white,
                    hintText: 'Офис/кв.',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    textInputType: TextInputType.number,
                    textEditingController: item3Controller,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
