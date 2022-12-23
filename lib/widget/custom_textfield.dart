import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CustomTextField extends StatelessWidget {
  final Function? onTap;
  final bool? readOnly;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final String hintText;
  final Icon? icon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController textEditingController;
  final Color? mainColor;
  final Color? bgColor;
  final int? maxLines;
  final List<TextInputFormatter>? formatters;
  final TextInputType? textInputType;
  final bool? obscureText;
  final FormFieldValidator<String>? validateFunction;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? suffixText;
  final Widget? prefixicon;
  final String? prefixText;
  final bool? enabled;
  final Color? fillColor;
  double? height;
  double? width;
  TextStyle? hintStyle;
  EdgeInsets? contentPadding;
  CustomTextField({
    Key? key,
    this.onTap,
    this.readOnly,
    this.inputAction,
    this.focusNode,
    required this.hintText,
    this.icon,
    this.onChanged,
    this.onFieldSubmitted,
    required this.textEditingController,
    this.mainColor,
    this.bgColor,
    this.maxLines,
    this.formatters,
    this.textInputType,
    this.obscureText,
    this.validateFunction,
    this.suffix,
    this.suffixIcon,
    this.suffixText,
    this.prefixicon,
    this.prefixText,
    this.enabled,
    this.fillColor,
    this.hintStyle = CustomTextStyle.textHintStyle,
    this.height,
    this.width,
    this.contentPadding = const EdgeInsets.only(bottom: 5, left: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color hintTextColor = Colors.grey;
    height = height ?? 175.h;
    hintStyle = hintStyle ??
        TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          color: hintTextColor,
          fontWeight: FontWeight.w400,
        );

    contentPadding = contentPadding ??
        EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w);

    var widthOfScreen = width ?? MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: widthOfScreen,
      child: KeyboardActions(
        disableScroll: true,
        config: KeyboardActionsConfig(
          defaultDoneWidget: GestureDetector(
            onTap: () {
              focusNode?.unfocus();
              if(onFieldSubmitted != null) {
                onFieldSubmitted!(textEditingController.text);
              }
            },
            child: const Text('Готово'),
          ),
          actions: [
            KeyboardActionsItem(
              focusNode: focusNode ?? FocusNode(),
              onTapAction: () => focusNode?.unfocus(),
            ),
          ],
        ),
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          focusNode: focusNode,
          onTap: onTap as void Function()?,
          validator: validateFunction,
          readOnly: readOnly ?? false,
          textInputAction: inputAction,
          controller: textEditingController,
          onChanged: onChanged,
          obscureText: obscureText ?? false,
          maxLines: 1,
          minLines: 1,
          inputFormatters: formatters,
          keyboardType: textInputType,
          style: const TextStyle(
              color: Colors.black, overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            fillColor: fillColor,
            icon: icon,
            prefixIcon: prefixicon,
            suffixText: suffixText,
            suffix: suffix,
            prefixText: prefixText,
            prefixStyle: const TextStyle(
                fontSize: 14.5,
                color: Colors.black,
                overflow: TextOverflow.ellipsis),
            suffixIcon: suffixIcon,
            suffixStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              color: hintTextColor,
              fontWeight: FontWeight.w400,
            ),
            errorStyle: const TextStyle(fontSize: 10.0),
            contentPadding: contentPadding,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
                style: BorderStyle.solid,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.0,
              style: BorderStyle.solid,
            )),
            hintStyle: hintStyle,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
