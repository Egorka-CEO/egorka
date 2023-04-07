import 'package:egorka/core/bloc/book/book_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/formatter_uppercase.dart';
import 'package:egorka/widget/list_books_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

Widget personalData(
  TextEditingController nameController,
  TextEditingController phoneController,
  FocusNode contactFocus,
  FocusNode phoneFocus,
  Function(BookAdresses) onTapBook,
  Function() onSubmitted,
) {
  return Column(
    children: [
      Container(
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                onFieldSubmitted: (value) => onSubmitted(),
                maxLines: 1,
                height: 45.h,
                focusNode: contactFocus,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                fillColor: Colors.white,
                hintText: 'Имя',
                formatters: [CustomInputFormatterUpperCase()],
                hintStyle: CustomTextStyle.textHintStyle,
                textEditingController: nameController,
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, snapshot) {
              final auth = BlocProvider.of<ProfileBloc>(context).getUser();
              if (auth == null) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () => showBooksAddress(
                  context,
                  BlocProvider.of<BookBloc>(context).books,
                  onTapBook,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Из книжки',
                      style: CustomTextStyle.red15,
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.menu_book,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
              );
            })
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Row(
        children: [
          Expanded(
            child: CustomTextField(
              onFieldSubmitted: (value) {
                if (phoneController.text == '+7 (') {
                  phoneController.text = '';
                }
                onSubmitted();
              },
              focusNode: phoneFocus,
              height: 45.h,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              fillColor: Colors.white,
              hintText: '+7 (999) 888-77-66',
              textInputType: TextInputType.number,
              textEditingController: phoneController,
              onTap: () {
                if (phoneController.text.isEmpty) {
                  phoneController.text = '+7 (';
                }
              },
              formatters: [
                MaskTextInputFormatter(
                  type: MaskAutoCompletionType.eager,
                  initialText: '+7 (',
                  mask: '+7 (###) ###-##-##',
                  filter: {"#": RegExp(r'[0-9]')},
                )
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
