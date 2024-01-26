import 'package:egorka/core/bloc/book/book_bloc.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:scale_button/scale_button.dart';

void showBooksAddress(BuildContext context, List<BookAdresses> bookAdresses,
        Function(BookAdresses) onSelect) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
          child: AlertDialog(
            insetPadding: EdgeInsets.only(top: 150.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Text(
                                      'Мои записки',
                                      style: CustomTextStyle.black17w400,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: const Icon(Icons.close),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<BookBloc, BookState>(
                            buildWhen: (previous, current) {
                              if (current is UpdateBook) {
                                bookAdresses.clear();
                                bookAdresses.addAll(
                                    BlocProvider.of<BookBloc>(context).books);
                                return true;
                              }
                              return false;
                            },
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 400.h,
                                width: MediaQuery.of(context).size.width - 20.w,
                                child: bookAdresses.isEmpty
                                    ? Column(
                                        children: [
                                          LottieBuilder.asset(
                                            'assets/anim/book_flip.json',
                                            height: 250.h,
                                          ),
                                          Text(
                                            'У вас пока что нет записей.\nВы можете перейти к записной книжке и добавить записи',
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await Navigator.of(context)
                                                  .pushNamed(AppRoute.book);
                                              BlocProvider.of<BookBloc>(context)
                                                  .add(LoadBooksEvent());
                                            },
                                            child: Container(
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Перейти',
                                                  style: CustomTextStyle
                                                      .white15w600
                                                      .copyWith(
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: bookAdresses.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: ((context, index) {
                                          return ScaleButton(
                                            bound: 0.01,
                                            onTap: () {
                                              onSelect(bookAdresses[index]);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              color: index % 2 != 0
                                                  ? Colors.white
                                                  : Colors.grey[200],
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        'Название: ',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        bookAdresses[index]
                                                                .name ??
                                                            '-',
                                                        style: TextStyle(
                                                            fontSize: 14.sp),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(width: 10.h),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        'Адрес: ',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        width: 280.w,
                                                        child: Text(
                                                          bookAdresses[index]
                                                                  .address ??
                                                              '-',
                                                          style: TextStyle(
                                                              fontSize: 14.sp),
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.h),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        'Имя: ',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        bookAdresses[index]
                                                                .contact
                                                                ?.name ??
                                                            '-',
                                                        style: TextStyle(
                                                            fontSize: 14.sp),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(width: 10.h),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10.h),
                                                      Text(
                                                        'Номер телефона: ',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        bookAdresses[index]
                                                                .contact
                                                                ?.phoneMobile ??
                                                            '-',
                                                        style: TextStyle(
                                                            fontSize: 14.sp),
                                                      ),
                                                      SizedBox(width: 10.h),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
