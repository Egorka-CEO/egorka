import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckBox extends StatefulWidget {
  final bool initialValue;
  final Function(bool value) onTap;
  const CustomCheckBox({
    super.key,
    required this.initialValue,
    required this.onTap,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool currentValue;

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentValue = !currentValue;
          widget.onTap(currentValue);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 20.h,
        width: 20.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: currentValue ? const Color.fromRGBO(255, 102, 102, 1) : null,
          border: Border.all(
            width: 2,
            color: currentValue
                ? const Color.fromRGBO(255, 102, 102, 1)
                : Colors.black,
          ),
        ),
        alignment: Alignment.center,
        child: currentValue
            ? Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16.h,
              )
            : null,
      ),
    );
  }
}
