import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/poinDetails.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/ui/sidebar/market_place/market_page.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailsPage extends StatelessWidget {
  int index;
  TypeAdd typeAdd;
  PointDetails routeOrder;

  DetailsPage({
    super.key,
    required this.index,
    required this.typeAdd,
    required this.routeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NewOrderPageBloc>(
            create: (context) => NewOrderPageBloc(),
          ),
        ],
        child: DetailsPageTemp(
          index: index,
          typeAdd: typeAdd,
          routeOrder: routeOrder,
        ));
  }
}

class DetailsPageTemp extends StatefulWidget {
  int index;
  TypeAdd typeAdd;
  PointDetails routeOrder;

  DetailsPageTemp({
    super.key,
    required this.index,
    required this.typeAdd,
    required this.routeOrder,
  });

  @override
  State<DetailsPageTemp> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPageTemp> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerEntrance = TextEditingController();
  TextEditingController controllerFloor = TextEditingController();
  TextEditingController controllerRoom = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerComment = TextEditingController();
  PanelController panelController = PanelController();

  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  void initState() {
    super.initState();
    controllerEntrance.text = widget.routeOrder.details?.entrance ?? '';
    controllerFloor.text = widget.routeOrder.details?.floor ?? '';
    controllerRoom.text = widget.routeOrder.details?.room ?? '';
    controllerName.text = widget.routeOrder.details?.name ?? '';
    controllerPhone.text = widget.routeOrder.details?.phone ?? '';
    controllerComment.text = widget.routeOrder.details?.comment ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: const SizedBox(),
          elevation: 0.5,
          flexibleSpace: Column(
            children: [
              const Spacer(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(
                                  context, widget.routeOrder.details),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 25.h,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'Назад',
                                    style: CustomTextStyle.red15
                                        .copyWith(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text('Удалить',
                                  style: CustomTextStyle.red15
                                      .copyWith(fontSize: 17)),
                            ),
                            Align(
                              child: Text(
                                'Указать детали',
                                style: CustomTextStyle.black15w500.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 80.w,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: widget.typeAdd == TypeAdd.sender
                              ? Colors.red
                              : Colors.blue,
                          width: 2.w,
                        ),
                      ),
                    ),
                    Text(
                      widget.typeAdd == TypeAdd.sender
                          ? 'А${widget.index}'
                          : 'Б${widget.index}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Text(
                        widget.typeAdd == TypeAdd.sender
                            ? 'Откуда забрать?'
                            : 'Куда отвезти?',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 20.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.text = '';
                                  typeAdd = TypeAdd.sender;
                                  setState(() {});
                                  panelController.animatePanelToPosition(
                                    1,
                                    curve: Curves.easeInOutQuint,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                  );
                                },
                                child: CustomTextField(
                                  height: 45.h,
                                  contentPadding: const EdgeInsets.all(0),
                                  fillColor: Colors.white.withOpacity(0),
                                  enabled: false,
                                  hintText: '',
                                  textEditingController: controller,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: const [
                      Text(
                        'Не обязательно к заполнению',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          height: 45.h,
                          fillColor: Colors.white,
                          hintText: 'Подъезд',
                          focusNode: FocusNode(),
                          onChanged: (value) {
                            widget.routeOrder.details?.entrance =
                                controllerEntrance.text;
                          },
                          textInputType: TextInputType.number,
                          textEditingController: controllerEntrance,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: CustomTextField(
                          height: 45.h,
                          fillColor: Colors.white,
                          hintText: 'Этаж',
                          focusNode: FocusNode(),
                          onChanged: (value) {
                            widget.routeOrder.details?.floor =
                                controllerFloor.text;
                          },
                          textInputType: TextInputType.number,
                          textEditingController: controllerFloor,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: CustomTextField(
                          height: 45.h,
                          fillColor: Colors.white,
                          hintText: 'Офис/кв.',
                          focusNode: FocusNode(),
                          onChanged: (value) {
                            widget.routeOrder.details?.room =
                                controllerRoom.text;
                          },
                          textInputType: TextInputType.number,
                          textEditingController: controllerRoom,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: const [
                      Text('Контакты получателя',
                          style: CustomTextStyle.grey15bold),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () {},
                    child: CustomTextField(
                      height: 45.h,
                      fillColor: Colors.white,
                      hintText: 'Имя',
                      onChanged: (value) {
                        widget.routeOrder.details?.name = controllerName.text;
                      },
                      textEditingController: controllerName,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () {},
                    child: CustomTextField(
                      height: 45.h,
                      fillColor: Colors.white,
                      hintText: '+7 (___) ___-__-__',
                      onChanged: (value) {
                        widget.routeOrder.details?.phone = controllerPhone.text;
                      },
                      textEditingController: controllerPhone,
                      formatters: [
                        CustomInputFormatter(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: const [
                      Text(
                        'Поручения для Егорки',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            height: 300.w,
                            width: 100.w,
                            fillColor: Colors.white.withOpacity(0),
                            hintText: '',
                            onChanged: (value) {
                              widget.routeOrder.details?.comment =
                                  controllerComment.text;
                            },
                            maxLines: 10,
                            textEditingController: controllerComment,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<NewOrderPageBloc, NewOrderState>(
              buildWhen: (previous, current) {
                if (current is NewOrderCloseBtmSheet) {
                  btmSheet = false;
                } else if (current is NewOrderStatedOpenBtmSheet) {
                  btmSheet = true;
                } else if (current is NewOrderStateCloseBtmSheet) {
                  btmSheet = false;
                  if (typeAdd != null && typeAdd == TypeAdd.sender) {
                  } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {}
                }
                return true;
              },
              builder: (context, snapshot) {
                return SlidingUpPanel(
                  color: Colors.white,
                  controller: panelController,
                  renderPanelSheet: false,
                  isDraggable: true,
                  collapsed: Container(),
                  panel: AddAdressBottomSheetDraggable(
                    typeAdd: widget.typeAdd,
                    fromController: controller,
                    panelController: panelController,
                  ),
                  onPanelClosed: () {},
                  onPanelOpened: () {},
                  onPanelSlide: (size) {},
                  maxHeight: 700.h,
                  minHeight: 0,
                  defaultPanelState: PanelState.CLOSED,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
