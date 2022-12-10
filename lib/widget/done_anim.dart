import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class DoneAnim extends StatefulWidget {
  @override
  State<DoneAnim> createState() => _DoneAnimState();
}

class _DoneAnimState extends State<DoneAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;

  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300.h,
        width: 300.h,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Lottie.asset("assets/anim/done.json",
                    controller: lottieController,
                    repeat: false, onLoaded: (composition) {
                  lottieController.duration = composition.duration;
                  lottieController.forward();
                }),
              ),
              const Text(
                'Заявка создана',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
