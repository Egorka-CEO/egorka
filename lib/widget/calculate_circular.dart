import 'package:egorka/helpers/app_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculateLoadingDialog extends StatelessWidget {
  const CalculateLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(),
                  // const SizedBox(height: 10),
                  Column(
                    children: [
                      // Text(
                      //   'Егорке нужно все посчитать',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 15),
                      // ),
                      // Text(
                      //   '🙃',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 20),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
