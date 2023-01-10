import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scale_button/scale_button.dart';

class StandartButton extends StatelessWidget {
  const StandartButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.icon,
    this.color,
    this.width,
  }) : super(key: key);

  final String label;
  final Function() onTap;
  final bool danger;
  final IconData? icon;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: ScaleButton(
        duration: const Duration(milliseconds: 150),
        bound: 0.05,
        onTap: onTap,
        child: Container(
          height: 50.h,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              if (icon != null)
                Positioned(
                  left: 15.w,
                  top: 0,
                  bottom: 0,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18.h,
                  ),
                ),
              Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
