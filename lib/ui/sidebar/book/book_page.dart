import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookPage extends StatefulWidget {
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() async {
    List<BookAdresses>? res = await Repository().getListBookAdress();
    if (res != null) {
      bookAdresses.clear();
      bookAdresses.addAll(res);
      setState(() {});
    }
  }

  List<BookAdresses> bookAdresses = [];

  TextEditingController floorController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController entranceController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0.5,
          title: const Text(
            'Записная книжка',
            style: CustomTextStyle.black15w500,
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      const Text(
                        'Поиск',
                        style: CustomTextStyle.black15w500,
                      ),
                      const Spacer(),
                      CustomTextField(
                        focusNode: FocusNode(),
                        hintText: 'По ключевым словам',
                        textEditingController: TextEditingController(),
                        width: 250.w,
                        fillColor: Colors.white,
                        height: 45.h,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookAdresses.length + 2,
                      itemBuilder: (context, index) {
                        if (bookAdresses.length == index - 1) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: ScaleButton(
                              onTap: showTipPallet,
                              bound: 0.01,
                              child: Container(
                                height: 40.h,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    'Добавить адрес',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (index == 0) {
                          return Container(
                            height: 50.h,
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                const Expanded(flex: 2, child: Text('№')),
                                SizedBox(width: 10.w),
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Адрес',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Обозначение',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          );
                        }
                        return Dismissible(
                          key: UniqueKey(),
                          confirmDismiss: bookAdresses.length == 1
                              ? (direction) async {
                                  return false;
                                }
                              : (direction) async {
                                  bool resDelete = await Repository()
                                      .deleteAddress(
                                          bookAdresses[index - 1].id!);

                                  if (resDelete)
                                    bookAdresses.removeAt(index - 1);

                                  return resDelete;
                                },
                          direction: DismissDirection.endToStart,
                          child: Container(
                            height: 50.h,
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Expanded(flex: 2, child: Text('$index')),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    bookAdresses[index - 1].address!,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    bookAdresses[index - 1].name!,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PanelController panelController = PanelController();

  void showTipPallet() => showDialog(
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
                  Container(
                    width: MediaQuery.of(context).size.width - 30.w,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Добавление адреса',
                                style: CustomTextStyle.black15w500,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          const Text('Адрес'),
                          CustomTextField(
                            focusNode: focusNode1,
                            hintText: 'ул.Ленина 27',
                            textEditingController: floorController,
                            fillColor: Colors.grey[100],
                            height: 45.h,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.w),
                          ),
                          SizedBox(height: 10.h),
                          const Text('Обозначение адреса'),
                          CustomTextField(
                            focusNode: focusNode2,
                            hintText: 'Дом',
                            textEditingController: nameController,
                            fillColor: Colors.grey[100],
                            height: 45.h,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.w),
                          ),
                          SizedBox(height: 10.h),
                          const Text('Подъезд'),
                          CustomTextField(
                            focusNode: focusNode3,
                            hintText: '3',
                            textEditingController: entranceController,
                            fillColor: Colors.grey[100],
                            height: 45.h,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.w),
                          ),
                          SizedBox(height: 10.h),
                          const Text('Квартира/офис'),
                          CustomTextField(
                            focusNode: focusNode4,
                            hintText: '23/3',
                            textEditingController: roomController,
                            fillColor: Colors.grey[100],
                            height: 45.h,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.w),
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              panelController.animatePanelToPosition(1);
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Записать в книжку',
                                  style: CustomTextStyle.white15w600.copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // AddAdressBottomSheetDraggable(
                  //   typeAdd: TypeAdd.receiver,
                  //   fromController: TextEditingController(),
                  //   panelController: panelController,
                  //   onSearch: (p0) {},
                  // )
                ],
              ),
            ),
          );
        },
      );
}
