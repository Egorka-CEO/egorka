import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StandardAlertDialog extends StatelessWidget {
  const StandardAlertDialog({
    Key? key,
    required this.message,
    required this.buttons,
  }) : super(key: key);

  final String message;
  final List<StandartButton> buttons;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd),
      child: Stack(
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 20.w),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 125.h,
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    if (buttons.length != 2)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buttons[index];
                        },
                        separatorBuilder: (context, index) {
                          if ((index + 1) == buttons.length) {
                            return const SizedBox.shrink();
                          }
                          return SizedBox(height: 15.h);
                        },
                        itemCount: buttons.length,
                      ),
                    if (buttons.length == 2)
                      Row(
                        children: [
                          Expanded(child: buttons[0]),
                          SizedBox(width: 15.w),
                          Expanded(child: buttons[1]),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
