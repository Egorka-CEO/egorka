import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FailAnim extends StatefulWidget {
  VoidCallback callBack;
  String? text;
  FailAnim({
    required this.callBack,
    this.text,
  });
  @override
  State<FailAnim> createState() => _FailAnimState();
}

class _FailAnimState extends State<FailAnim>
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
        // Navigator.pop(context);
        widget.callBack();
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
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300.h,
                width: 300.h,
                child: Expanded(
                  child: Lottie.asset("assets/anim/fail.json",
                      controller: lottieController,
                      repeat: false, onLoaded: (composition) {
                    lottieController.duration = composition.duration;
                    lottieController.forward();
                  }),
                ),
              ),
              const Text(
                'Отклонено',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              if (widget.text != null)
                Text(
                  widget.text!,
                  style: const TextStyle(
                    fontSize: 13,
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
