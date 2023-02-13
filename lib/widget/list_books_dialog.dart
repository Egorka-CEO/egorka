import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scale_button/scale_button.dart';

void showBooksAddress(BuildContext context, List<BookAdresses> bookAdresses,
        Function(BookAdresses) onSelect) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                                      style: CustomTextStyle.black15w500,
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
                          SizedBox(
                            height: 400.h,
                            width: MediaQuery.of(context).size.width - 20.w,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: bookAdresses.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: ((context, index) {
                                // if (index == 0) {
                                //   return Container(
                                //     height: 50.h,
                                //     color: index % 2 == 0
                                //         ? Colors.white
                                //         : Colors.grey[200],
                                //     child: Row(
                                //       children: [
                                //         SizedBox(width: 10.w),
                                //         const Expanded(
                                //             flex: 2, child: Text('№')),
                                //         SizedBox(width: 10.w),
                                //         const Expanded(
                                //           flex: 4,
                                //           child: Text(
                                //             'Адрес',
                                //             textAlign: TextAlign.center,
                                //           ),
                                //         ),
                                //         const Expanded(
                                //           flex: 3,
                                //           child: Text(
                                //             'Обозначение',
                                //             textAlign: TextAlign.center,
                                //           ),
                                //         ),
                                //         SizedBox(width: 10.w),
                                //       ],
                                //     ),
                                //   );
                                // }
                                return ScaleButton(
                                  bound: 0.01,
                                  onTap: () {
                                    onSelect(bookAdresses[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    // height: 50.h,
                                    color: index % 2 != 0
                                        ? Colors.white
                                        : Colors.grey[200],
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     SizedBox(width: 10.w),
                                        //     Expanded(
                                        //         flex: 2, child: Text('$index')),
                                        //     Expanded(
                                        //       flex: 4,
                                        //       child: Text(
                                        //         bookAdresses[index - 1]
                                        //             .address!,
                                        //         style:
                                        //             TextStyle(fontSize: 14.sp),
                                        //         textAlign: TextAlign.center,
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 3,
                                        //       child: Column(
                                        //         children: [
                                        //           SizedBox(height: 3.h),
                                        //           Text(
                                        //             bookAdresses[index - 1]
                                        //                 .name!,
                                        //             textAlign: TextAlign.center,
                                        //             style: TextStyle(
                                        //                 fontSize: 14.sp),
                                        //           ),
                                        //           SizedBox(height: 3.h)
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: 10.w),
                                        //   ],
                                        // ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.h),
                                            Text(
                                              'Название: ',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              bookAdresses[index].name ?? '-',
                                              style: TextStyle(fontSize: 14.sp),
                                              textAlign: TextAlign.center,
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
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 280.w,
                                              child: Text(
                                                bookAdresses[index].address ??
                                                    '-',
                                                style:
                                                    TextStyle(fontSize: 14.sp),
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
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              bookAdresses[index]
                                                      .contact
                                                      ?.name ??
                                                  '-',
                                              style: TextStyle(fontSize: 14.sp),
                                              textAlign: TextAlign.center,
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
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              bookAdresses[index]
                                                      .contact
                                                      ?.phoneMobile ??
                                                  '-',
                                              style: TextStyle(fontSize: 14.sp),
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
