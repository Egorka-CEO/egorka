import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/model/suggestions.dart';
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
      bookAdressesTemp.clear();
      bookAdressesTemp.addAll(res);
      setState(() {});
    }
  }

  List<BookAdresses> bookAdresses = [];
  List<BookAdresses> bookAdressesTemp = [];

  TextEditingController searchController = TextEditingController();

  TextEditingController floorController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController entranceController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController btmController = TextEditingController();

  FocusNode focusSearch = FocusNode();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusbtm = FocusNode();

  Address? address;

  Suggestions? selectAddress;

  PanelController panelController = PanelController();

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
                      const Text('Поиск', style: CustomTextStyle.black15w500),
                      SizedBox(width: 20.w),
                      CustomTextField(
                        focusNode: focusSearch,
                        hintText: 'По ключевым словам',
                        textEditingController: searchController,
                        width: 250.w,
                        fillColor: Colors.white,
                        height: 45.h,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        onChanged: (value) {
                          bookAdresses.clear();
                          for (var element in bookAdressesTemp) {
                            if (element.name!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                element.address!
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                              bookAdresses.add(element);
                            }
                          }
                          setState(() {});
                        },
                      ),
                      const Spacer(),
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
                              onTap: showAddAddress,
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
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: Text(
                                  'Удалить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          confirmDismiss: bookAdresses.length == 1
                              ? (direction) async {
                                  return false;
                                }
                              : (direction) async {
                                  bool resDelete = await Repository()
                                      .deleteAddress(
                                          bookAdresses[index - 1].id!);

                                  if (resDelete) {
                                    bookAdresses.removeAt(index - 1);
                                  }

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

  void showAddAddress() => showDialog(
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.4),
        context: context,
        builder: (context) {
          selectAddress = null;
          nameController.text = '';
          entranceController.text = '';
          floorController.text = '';
          roomController.text = '';
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              insetPadding: EdgeInsets.only(top: 150.h),
              alignment: Alignment.center,
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
                                        'Добавление адреса',
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
                            SizedBox(height: 20.h),
                            const Text('Адрес'),
                            GestureDetector(
                              onTap: () {
                                panelController.animatePanelToPosition(1);
                              },
                              child: CustomTextField(
                                focusNode: focusNode1,
                                hintText: 'ул.Ленина 27',
                                textEditingController: floorController,
                                fillColor: Colors.grey[100],
                                enabled: false,
                                height: 45.h,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.w),
                              ),
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
                              onTap: () async {
                                if (selectAddress != null &&
                                    nameController.text.isNotEmpty &&
                                    entranceController.text.isNotEmpty &&
                                    floorController.text.isNotEmpty &&
                                    roomController.text.isNotEmpty) {
                                  bool res = await Repository().addAddress(
                                    BookAdresses(
                                      id: '',
                                      code: selectAddress!.iD,
                                      name: nameController.text,
                                      address: selectAddress!.name,
                                      entrance: entranceController.text,
                                      floor: floorController.text,
                                      room: roomController.text,
                                      latitude: 0,
                                      longitude: 0,
                                    ),
                                  );
                                  if (res) {
                                    Navigator.of(context).pop();
                                  }
                                  updateList();
                                }
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
                  ),
                  SlidingUpPanel(
                    controller: panelController,
                    renderPanelSheet: false,
                    isDraggable: true,
                    collapsed: Container(),
                    minHeight: 0,
                    maxHeight: 900.h,
                    borderRadius: BorderRadius.circular(15.r),
                    panel: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          topRight: Radius.circular(15.r),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.w,
                              left: ((MediaQuery.of(context).size.width * 47) /
                                      100)
                                  .w,
                              right: ((MediaQuery.of(context).size.width * 47) /
                                      100)
                                  .w,
                              bottom: 10.w,
                            ),
                            child: Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    height: 45.h,
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        focusbtm.requestFocus();
                                      });
                                    },
                                    focusNode: focusbtm,
                                    fillColor: Colors.grey[100],
                                    hintText: 'ул.Межевая 42',
                                    onFieldSubmitted: (text) {
                                      focusbtm.unfocus();
                                    },
                                    textEditingController: btmController,
                                    onChanged: (value) async {
                                      address = null;
                                      setState(() {});
                                      if (value.length > 1) {
                                        address = await Repository()
                                            .getAddress(value);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _searchList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _searchList() {
    // print('object twtewtyetwyeyw ${address}-${address!.result.suggestions}');
    if (address == null || address!.result.suggestions!.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 300.h,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: address?.result.suggestions!.length,
          itemBuilder: (context, index) {
            return _pointCard(
                address?.result.suggestions![index], index, context);
          },
        ),
      ),
    );
  }

  Widget _pointCard(Suggestions? suggestions, int index, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
          height: 50.h,
          child: InkWell(
            onTap: () {
              btmController.text = '';
              focusbtm.unfocus();
              panelController.close();
              address = null;
              selectAddress = suggestions;
              floorController.text = selectAddress!.name;
              setState(() {});
            },
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  flex: 10,
                  child: Text(
                    suggestions!.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 0.5.h,
          color: Colors.grey[400],
          width: double.infinity,
        ),
      ],
    );
  }
}
