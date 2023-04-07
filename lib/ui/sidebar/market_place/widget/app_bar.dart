import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSizeWidget marketPlaceAppBar(
  BuildContext context,
  GlobalKey iconBtn,
) {
  return AppBar(
    backgroundColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.5),
    leading: const SizedBox(),
    elevation: 0.5,
    flexibleSpace: Column(
      children: [
        const Spacer(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Отмена',
                          style: CustomTextStyle.red15,
                        ),
                      ),
                      Align(
                        child: Row(
                          children: [
                            SizedBox(width: 15.w),
                            GestureDetector(
                              onTap: () => iconSelectModal(
                                context,
                                getWidgetPosition(iconBtn),
                                (index) {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();
                                },
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    key: iconBtn,
                                  ),
                                  SizedBox(width: 15.w),
                                  const Text(
                                    'Доставка до маркетплейса',
                                    style: CustomTextStyle.black17w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
