import 'package:egorka/core/bloc/book/book_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/model/contact.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_uppercase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookPage extends StatefulWidget {
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<BookAdresses> bookAdresses = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController entranceController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController btmController = TextEditingController();
  TextEditingController fioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode focusSearch = FocusNode();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  FocusNode focusNode7 = FocusNode();
  FocusNode focusbtm = FocusNode();

  Address? address;
  Suggestions? selectAddress;
  PanelController panelController = PanelController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookBloc>(context).add(LoadBooksEvent());
    bookAdresses.addAll(BlocProvider.of<BookBloc>(context).books);
  }

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
                          final bloc = BlocProvider.of<BookBloc>(context);
                          bookAdresses.clear();
                          List<BookAdresses> bookAdressesTemp = [];
                          for (var element in bloc.books) {
                            if (element.name!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                element.address!
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                              bookAdressesTemp.add(element);
                            }
                            if (value.isEmpty) {
                              bookAdresses.addAll(bloc.books);
                            } else {
                              bookAdresses.addAll(bookAdressesTemp);
                            }
                          }
                          setState(() {});
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<BookBloc, BookState>(
                    builder: (context, snapshot) {
                      if (snapshot is UpdateBook) {
                        bookAdresses.clear();
                        final books = BlocProvider.of<BookBloc>(context).books;
                        List<BookAdresses> bookAdressesTemp = [];
                        for (var element in books) {
                          if (element.name!.toLowerCase().contains(
                                  searchController.text.toLowerCase()) ||
                              element.address!.toLowerCase().contains(
                                  searchController.text.toLowerCase()) ||
                              element.contact!.phoneMobile!
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase())) {
                            bookAdressesTemp.add(element);
                          }
                        }
                        if (searchController.text.isEmpty) {
                          bookAdresses.addAll(books);
                        } else {
                          bookAdresses.addAll(bookAdressesTemp);
                        }
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: bookAdresses.length + 2,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (bookAdresses.length == index - 1) {
                              return Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: ScaleButton(
                                  onTap: () {
                                    selectAddress = null;
                                    address = null;
                                    nameController.text = '';
                                    entranceController.text = '';
                                    floorController.text = '';
                                    roomController.text = '';
                                    fioController.text = '';
                                    phoneController.text = '';
                                    showAddAddress();
                                  },
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
                                    Expanded(
                                      child: Text(
                                        'Обозначение',
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        'Адрес',
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Телефон',
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
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

                                      BlocProvider.of<BookBloc>(context)
                                          .add(LoadBooksEvent());

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
                                    Expanded(
                                      child: Text(
                                        bookAdresses[index - 1].name!,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bookAdresses[index - 1].address!,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bookAdresses[index - 1]
                                                .contact
                                                ?.phoneMobile ??
                                            '-',
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
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
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: StatefulBuilder(builder: (context, snapshot) {
              return AlertDialog(
                insetPadding: EdgeInsets.only(top: 100.h),
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
                              SizedBox(
                                height: 400.h -
                                    MediaQuery.of(context).viewInsets.bottom /
                                        4,
                                width: MediaQuery.of(context).size.width - 30.w,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const ClampingScrollPhysics(),
                                  children: [
                                    const Text('Адрес'),
                                    GestureDetector(
                                      onTap: () {
                                        panelController
                                            .animatePanelToPosition(1);
                                      },
                                      child: CustomTextField(
                                        focusNode: focusNode1,
                                        hintText: 'ул.Ленина 27',
                                        textEditingController:
                                            addressController,
                                        fillColor: Colors.grey[100],
                                        enabled: false,
                                        height: 45.h,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Обозначение'),
                                    CustomTextField(
                                      focusNode: focusNode2,
                                      hintText: 'Дом',
                                      textEditingController: nameController,
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Этаж'),
                                    CustomTextField(
                                      focusNode: focusNode3,
                                      hintText: '3',
                                      textEditingController: floorController,
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Подъезд'),
                                    CustomTextField(
                                      focusNode: focusNode4,
                                      hintText: '3',
                                      textEditingController: entranceController,
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Квартира/офис'),
                                    CustomTextField(
                                      focusNode: focusNode5,
                                      hintText: '23/3',
                                      textEditingController: roomController,
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Имя и фамилия'),
                                    CustomTextField(
                                      focusNode: focusNode6,
                                      hintText: 'Иван Иванов',
                                      textEditingController: fioController,
                                      formatters: [
                                        CustomInputFormatterUpperCase()
                                      ],
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Text('Телефон'),
                                    CustomTextField(
                                      focusNode: focusNode7,
                                      hintText: '+7 999-888-7766',
                                      formatters: [
                                        MaskTextInputFormatter(
                                          initialText: '+7 ',
                                          mask: '+7 ###-###-####',
                                          filter: {"#": RegExp(r'[0-9]')},
                                        )
                                      ],
                                      textEditingController: phoneController,
                                      fillColor: Colors.grey[100],
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              GestureDetector(
                                onTap: () async {
                                  if (selectAddress != null &&
                                      nameController.text.isNotEmpty &&
                                      entranceController.text.isNotEmpty &&
                                      floorController.text.isNotEmpty &&
                                      roomController.text.isNotEmpty &&
                                      fioController.text.isNotEmpty &&
                                      phoneController.text.isNotEmpty &&
                                      addressController.text.isNotEmpty) {
                                    bool res = await Repository().addAddress(
                                      BookAdresses(
                                          id: '',
                                          code: selectAddress!.iD,
                                          name: nameController.text,
                                          address: addressController.text,
                                          entrance: entranceController.text,
                                          floor: floorController.text,
                                          room: roomController.text,
                                          latitude: 0,
                                          longitude: 0,
                                          contact: Contact(
                                            name: fioController.text,
                                            phoneMobile: phoneController.text,
                                          )),
                                    );
                                    if (res) {
                                      Navigator.of(context).pop();
                                    }
                                    BlocProvider.of<BookBloc>(context)
                                        .add(LoadBooksEvent());
                                  } else {
                                    String error = '';
                                    if (floorController.text.isEmpty) {
                                      error = 'Укажите адрес';
                                    } else if (nameController.text.isEmpty) {
                                      error = 'Укажите этаж';
                                    } else if (entranceController
                                        .text.isEmpty) {
                                      error = 'Укажите подъезд';
                                    } else if (roomController.text.isEmpty) {
                                      error = 'Укажите номер квартиры/офиса';
                                    } else if (fioController.text.isEmpty) {
                                      error = 'Укажите Фамилию и Имя';
                                    } else if (phoneController.text.isEmpty) {
                                      error = 'Укажите номер телефона';
                                    }
                                    MessageDialogs().showAlert('Ошибка', error);
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
                                      style:
                                          CustomTextStyle.white15w600.copyWith(
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
                      onPanelOpened: () {
                        focusbtm.requestFocus();
                      },
                      onPanelSlide: (value) {
                        if (value == 0) {
                          BlocProvider.of<BookBloc>(context).emit(BookStated());
                          // btmController.text = '';
                        }
                      },
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
                                left:
                                    ((MediaQuery.of(context).size.width * 47) /
                                            100)
                                        .w,
                                right:
                                    ((MediaQuery.of(context).size.width * 47) /
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
                                        if (value.length > 1) {
                                          BlocProvider.of<BookBloc>(context)
                                              .add(GetAddressEvent(value));
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
              );
            }),
          );
        },
      );

  Widget _searchList() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, snapshot) {
        if (snapshot is LoadingState) {
          return const CupertinoActivityIndicator();
        } else if (snapshot is GetAddress) {
          address = snapshot.address;
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
        return const SizedBox();
      },
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
              panelController.animatePanelToPosition(0);
              selectAddress = suggestions;
              addressController.text = selectAddress!.name;
              BlocProvider.of<BookBloc>(context).emit(BookStated());
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
