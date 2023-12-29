import 'package:egorka/core/bloc/book/book_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/model/contact.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_uppercase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w)
                .add(MediaQuery.of(context).viewInsets),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      margin: EdgeInsets.only(top: 76.h),
                      child: Row(
                        children: [
                          // SizedBox(width: 20.w),
                          SvgPicture.asset(
                            'assets/icons/arrow-left.svg',
                            width: 30.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Назад',
                            style: GoogleFonts.manrope(
                              fontSize: 17.h,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 64.h),
                  Text(
                    'Добавить адрес',
                    style: GoogleFonts.manrope(
                      fontSize: 25.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Адрес',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      panelController.animatePanelToPosition(1);
                    },
                    child: CustomTextField(
                      height: 64.h,
                      hintText: 'Ул.Садовая',
                      auth: true,
                      enabled: false,
                      textEditingController: addressController,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Обозначение',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'Дом',
                    height: 64.h,
                    auth: true,
                    textEditingController: nameController,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Этаж',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: '3',
                    height: 64.h,
                    auth: true,
                    textInputType: TextInputType.number,
                    textEditingController: floorController,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Подъезд',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    height: 64.h,
                    hintText: '3',
                    auth: true,
                    textInputType: TextInputType.number,
                    textEditingController: entranceController,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Квартира/офис',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: '23/3',
                    height: 64.h,
                    textInputType: TextInputType.number,
                    auth: true,
                    textEditingController: roomController,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Имя Фамилия',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    height: 64.h,
                    auth: true,
                    hintText: 'Иван Иванов',
                    formatters: [CustomInputFormatterUpperCase()],
                    textEditingController: fioController,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Номер телефона',
                    style: GoogleFonts.manrope(
                      fontSize: 17.h,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: '+7 999-888-7766',
                    auth: true,
                    height: 64.h,
                    textInputType: TextInputType.phone,
                    textEditingController: phoneController,
                    formatters: [
                      MaskTextInputFormatter(
                        initialText: '+7 ',
                        mask: '+7 ###-###-####',
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                      title: 'Готово',
                      onTap: () async {
                        print(nameController.text);
                        if (selectAddress != null &&
                            nameController.text.isNotEmpty &&
                            // entranceController.text.isNotEmpty &&
                            // floorController.text.isNotEmpty &&
                            // roomController.text.isNotEmpty &&
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
                          } else if (entranceController.text.isEmpty) {
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
                      }),
                  SizedBox(height: 354.h),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: panelController,
            renderPanelSheet: false,
            isDraggable: true,
            collapsed: Container(),
            minHeight: 0,
            maxHeight: 760.h,
            borderRadius: BorderRadius.circular(15.r),
            onPanelOpened: () {
              focusbtm.requestFocus();
            },
            onPanelClosed: () {
              focusbtm.unfocus();
            },
            onPanelSlide: (value) {
              if (value == 0) {
                BlocProvider.of<BookBloc>(context).emit(BookStated());
              }
            },
            panel: Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromRGBO(51, 51, 51, 0.2),
                      blurRadius: 50.r,
                      offset: Offset(20, 0))
                ],
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.w,
                      left: ((MediaQuery.of(context).size.width * 47) / 100).w,
                      right: ((MediaQuery.of(context).size.width * 47) / 100).w,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            height: 64.h,
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                focusbtm.requestFocus();
                              });
                            },
                            focusNode: focusbtm,
                            fillColor: Colors.grey[100],
                            hintText: 'ул.Межевая 42',
                            auth: true,
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
  }

  Widget _searchList() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, snapshot) {
        if (snapshot is LoadingState) {
          return Padding(
            padding: EdgeInsets.only(top: 200.h),
            child: const CupertinoActivityIndicator(),
          );
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
