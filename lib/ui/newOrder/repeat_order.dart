import 'dart:async';
import 'dart:io';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/delivery_type.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/poinDetails.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/calculate_circular.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_max_coast.dart';
import 'package:egorka/widget/formatter_slider.dart';
import 'package:egorka/widget/load_form.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:egorka/widget/total_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RepeatOrderPage extends StatelessWidget {
  int recordNumber, recordPIN;

  RepeatOrderPage({
    required this.recordNumber,
    required this.recordPIN,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NewOrderPageBloc>(
            create: (context) => NewOrderPageBloc(),
          ),
        ],
        child: RepeatOrderPageState(
          recordNumber: recordNumber,
          recordPIN: recordPIN,
        ),
      ),
    );
  }
}

class RepeatOrderPageState extends StatefulWidget {
  int recordNumber, recordPIN;

  RepeatOrderPageState({
    required this.recordNumber,
    required this.recordPIN,
    super.key,
  });

  @override
  State<RepeatOrderPageState> createState() => _RepeatOrderPageState();
}

class _RepeatOrderPageState extends State<RepeatOrderPageState> {
  List<PointDetails> routeOrderSender = [];
  List<PointDetails> routeOrderReceiver = [];

  double minSlider = 0;
  double maxSlider = 200;

  bool btmSheet = false;
  TypeAdd? typeAdd;
  InfoForm? formOrder;
  CoastResponse? coasts;

  DateTime? time;

  bool attorney = false;
  bool industrialZone = false;
  bool toDoor = false;
  bool additional = false;
  bool additional1 = false;
  bool additional2 = false;
  bool additional3 = false;
  bool additional4 = false;

  TextEditingController fromController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController coastController = TextEditingController();

  TextEditingController weigthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController depthController = TextEditingController();

  TextEditingController whereDeparture1 = TextEditingController();
  TextEditingController whoDeparture1 = TextEditingController();
  TextEditingController numberDeparture1 = TextEditingController();
  TextEditingController contactDeparture1 = TextEditingController();

  TextEditingController whereDeparture2 = TextEditingController();
  TextEditingController whoDeparture2 = TextEditingController();
  TextEditingController numberDeparture2 = TextEditingController();
  TextEditingController contactDeparture2 = TextEditingController();

  TextEditingController whereToSend = TextEditingController();
  TextEditingController whoToSend = TextEditingController();

  TextEditingController startOrderController = TextEditingController();

  final weightControllerSlider = StreamController<int>();
  final additionalController = StreamController<bool>();
  final additional1Controller = StreamController<bool>();
  final additional2Controller = StreamController<bool>();
  final additional3Controller = StreamController<bool>();
  final additional4Controller = StreamController<bool>();

  PanelController panelController = PanelController();
  ScrollController scrollController = ScrollController();

  final FocusNode whatDrive = FocusNode();
  final FocusNode whatCoast = FocusNode();
  final FocusNode weigthFocus = FocusNode();
  final FocusNode widthFocus = FocusNode();
  final FocusNode heightFocus = FocusNode();
  final FocusNode depthFocus = FocusNode();
  final FocusNode whereFocus = FocusNode();
  final FocusNode whoFocus = FocusNode();

  FocusNode whereDeparture1Focus = FocusNode();
  FocusNode whoDeparture1Focus = FocusNode();
  FocusNode numberDeparture1Focus = FocusNode();
  FocusNode contactDeparture1Focus = FocusNode();

  FocusNode whereDeparture2Focus = FocusNode();
  FocusNode whoDeparture2Focus = FocusNode();
  FocusNode numberDeparture2Focus = FocusNode();
  FocusNode contactDeparture2Focus = FocusNode();

  GlobalKey iconDate = GlobalKey();

  @override
  void initState() {
    super.initState();
    getForm();
  }

  @override
  void dispose() {
    weightControllerSlider.close();
    additionalController.close();
    additional1Controller.close();
    additional2Controller.close();
    additional3Controller.close();
    additional4Controller.close();
    super.dispose();
  }

  void getForm() async {
    formOrder = await Repository()
        .infoForm(widget.recordNumber.toString(), widget.recordPIN.toString());

    for (var element in formOrder!.result!.locations!) {
      if (element.type == 'Pickup') {
        routeOrderSender.add(
          PointDetails(
            suggestions: Suggestions(
                iD: '', name: element.point!.address!, point: element.point),
            details: Details(
              suggestions: Suggestions(
                  iD: '', name: element.point!.address!, point: element.point),
              entrance: element.point!.entrance,
              floor: element.point!.floor,
              room: element.point!.room,
              name: element.contact!.name,
              phone: element.contact!.phoneMobile,
              comment: element.message,
            ),
          ),
        );
      } else {
        routeOrderReceiver.add(
          PointDetails(
            suggestions: Suggestions(
                iD: '', name: element.point!.address!, point: element.point),
            details: Details(
              suggestions: Suggestions(
                  iD: '', name: element.point!.address!, point: element.point),
              entrance: element.point!.entrance,
              floor: element.point!.floor,
              room: element.point!.room,
              name: element.contact!.name,
              phone: element.contact!.phoneMobile,
              comment: element.message,
            ),
          ),
        );
      }
    }

    calc();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool keyBoardVisible = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Отмена',
                              style:
                                  CustomTextStyle.red15.copyWith(fontSize: 17),
                            ),
                          ),
                          Align(
                            child: Text(
                              'Оформление заказа',
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
      body: formOrder == null
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              children: [
                BlocBuilder<NewOrderPageBloc, NewOrderState>(
                  buildWhen: (previous, current) {
                    if (current is NewOrderCloseBtmSheet) {
                      btmSheet = false;
                    } else if (current is NewOrderStatedOpenBtmSheet) {
                      btmSheet = true;
                    } else if (current is NewOrderStateCloseBtmSheet) {
                      btmSheet = false;
                      if (typeAdd != null && typeAdd == TypeAdd.sender) {
                        routeOrderSender.add(PointDetails(
                            suggestions: current.value!, details: Details()));
                        calc();
                      } else if (typeAdd != null &&
                          typeAdd == TypeAdd.receiver) {
                        routeOrderReceiver.add(PointDetails(
                            suggestions: current.value!, details: Details()));
                        calc();
                      }
                    } else if (current is CalcSuccess) {
                      coasts = current.coasts ?? coasts;
                    } else if (current is CreateFormSuccess) {
                      BlocProvider.of<HistoryOrdersBloc>(context)
                          .add(GetListOrdersEvent());
                      MessageDialogs()
                          .completeDialog(text: 'Заявка создана')
                          .then((value) {
                        Navigator.of(context)
                          ..pop()
                          ..pushNamed(AppRoute.currentOrder, arguments: [
                            current.createFormModel.result.RecordNumber!,
                            current.createFormModel.result.RecordPIN!
                          ]);
                      });
                    } else if (current is CreateFormFail) {
                      String errors = '';
                      MessageDialogs()
                          .errorDialog(text: 'Отклонено', error: errors);
                    }
                    return true;
                  },
                  builder: (context, snapshot) {
                    return Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            controller: scrollController,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15.h),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, bottom: 8.w),
                                        child: const Text(
                                          'Отправитель',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: routeOrderSender.length,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          return dismissible(routeOrderSender,
                                              index, TypeAdd.sender);
                                        },
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              typeAdd = TypeAdd.sender;
                                              BlocProvider.of<NewOrderPageBloc>(
                                                      context)
                                                  .add(NewOrderOpenBtmSheet());
                                              panelController
                                                  .animatePanelToPosition(
                                                1,
                                                curve: Curves.easeInOutQuint,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                              );
                                            },
                                            child: Text(
                                              'Добавить отправителя',
                                              style: CustomTextStyle.red15
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, bottom: 8.w),
                                        child: const Text(
                                          'Получатель',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: routeOrderReceiver.length,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: ((context, index) {
                                          return dismissible(routeOrderReceiver,
                                              index, TypeAdd.receiver);
                                        }),
                                      ),
                                      SizedBox(height: 10.h),
                                      GestureDetector(
                                        onTap: () {
                                          typeAdd = TypeAdd.receiver;
                                          BlocProvider.of<NewOrderPageBloc>(
                                                  context)
                                              .add(NewOrderOpenBtmSheet());
                                          panelController
                                              .animatePanelToPosition(
                                            1,
                                            curve: Curves.easeInOutQuint,
                                            duration: const Duration(
                                                milliseconds: 1000),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Добавить получателя',
                                              style: CustomTextStyle.red15
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      SizedBox(width: 5.w),
                                      const Text(
                                        'Когда забрать?',
                                        style: CustomTextStyle.grey15bold,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: showDateTime,
                                            child: CustomTextField(
                                              height: 45.h,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                              fillColor: Colors.grey[200],
                                              hintText: '',
                                              enabled: false,
                                              textEditingController:
                                                  startOrderController,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        GestureDetector(
                                          onTap: () => iconDateOrder(
                                            context,
                                            getWidgetPosition(iconDate),
                                          ),
                                          child: Icon(
                                            Icons.help_outline_outlined,
                                            key: iconDate,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, top: 10.w, bottom: 8.w),
                                        child: const Text(
                                          'Что везем?',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      CustomTextField(
                                        height: 45.h,
                                        focusNode: whatDrive,
                                        onFieldSubmitted: (value) => calc(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.w),
                                        hintStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText:
                                            'Документы / Цветы / Техника / Личная вещь',
                                        textEditingController:
                                            documentController,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, top: 10.w, bottom: 8.w),
                                        child: const Text(
                                          'Ценность вашего груза?',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      CustomTextField(
                                        focusNode: whatCoast,
                                        onFieldSubmitted: (value) => calc(),
                                        onTap: () {
                                          scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.bounceIn,
                                          );
                                        },
                                        height: 45.h,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.w),
                                        hintStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText: 'До 100000 ₽',
                                        formatters: [
                                          CustomInputFormatterMaxCoast()
                                        ],
                                        textEditingController: coastController,
                                        textInputType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  StreamBuilder<bool>(
                                    stream: additionalController.stream,
                                    initialData: false,
                                    builder: (context, snapshot) {
                                      additional = snapshot.data!;
                                      double height;
                                      if (additional) {
                                        height = 1080.h;
                                        if (additional1) height += 175.h;
                                        if (additional2) height += 150.h;
                                        if (additional3) height += 315.h;
                                        if (additional4) height += 315.h;
                                      } else {
                                        height = 0.h;
                                      }
                                      return additionalTab(height);
                                    },
                                  ),
                                  keyBoardVisible
                                      ? formOrder == null
                                          ? SizedBox(height: 0.h)
                                          : SizedBox(height: 260.h)
                                      : SizedBox(height: 400.h)
                                ],
                              ),
                            ),
                          ),
                          if (coasts != null)
                            BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, snapshot) {
                              return TotalPriceWidget(
                                title: formOrder!.result!.type == 'Car'
                                    ? listChoice[0].title
                                    : listChoice[1].title,
                                icon: formOrder!.result!.type == 'Car'
                                    ? listChoice[0].icon
                                    : listChoice[1].icon,
                                deliveryCost:
                                    (((coasts!.result!.totalPrice!.base!)
                                                .ceil()) /
                                            100)
                                        .ceil()
                                        .toString(),
                                additionalCost:
                                    (((coasts!.result!.totalPrice!.ancillary!)
                                                .ceil()) /
                                            100)
                                        .ceil()
                                        .toString(),
                                comissionPaymentSystem: ((double.tryParse(
                                                    coasts!.result!.totalPrice!
                                                        .total!)!
                                                .ceil() *
                                            2.69) /
                                        100)
                                    .ceil()
                                    .toString(),
                                totalPrice:
                                    '${double.tryParse(coasts!.result!.totalPrice!.total!)!.ceil()}',
                                onTap: () {
                                  if (time == null) {
                                    MessageDialogs().showAlert('Ошибка',
                                        'Укажите дату когда нужно забрать');
                                  } else {
                                    BlocProvider.of<NewOrderPageBloc>(context)
                                        .add(CreateForm(coasts!.result!.id!));
                                  }
                                },
                              );
                            }),
                          SlidingUpPanel(
                            controller: panelController,
                            renderPanelSheet: false,
                            isDraggable: true,
                            collapsed: Container(),
                            panel: AddAdressBottomSheetDraggable(
                              typeAdd: typeAdd,
                              fromController: fromController,
                              panelController: panelController,
                              onSearch: (sug) {
                                panelController.animatePanelToPosition(
                                  0,
                                  curve: Curves.easeInOutQuint,
                                  duration: const Duration(
                                    milliseconds: 1000,
                                  ),
                                );

                                btmSheet = false;
                                if (typeAdd != null &&
                                    typeAdd == TypeAdd.sender) {
                                  routeOrderSender.add(PointDetails(
                                      suggestions: sug, details: Details()));
                                  calc();
                                } else if (typeAdd != null &&
                                    typeAdd == TypeAdd.receiver) {
                                  routeOrderReceiver.add(PointDetails(
                                      suggestions: sug, details: Details()));
                                  calc();
                                }
                              },
                            ),
                            onPanelClosed: () {
                              fromController.text = '';
                            },
                            onPanelOpened: () {},
                            onPanelSlide: (size) {},
                            maxHeight: 700.h,
                            minHeight: 0,
                            defaultPanelState: PanelState.CLOSED,
                          ),
                          if (snapshot is CalcLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.transparent,
                                child: CalculateLoadingDialog(),
                              ),
                            ),
                          if (snapshot is CreateFormState)
                            Positioned.fill(
                              child: Container(
                                color: Colors.transparent,
                                child: LoadForm(),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }

  Widget additionalTab(double height) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 5.w),
            const Text(
              'Дополнительные услуги',
              style: CustomTextStyle.grey15bold,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                additionalController.add(!additional);
                if (!additional) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    scrollController.animateTo(350.h,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear);
                  });
                }
              },
              child: Text(
                additional ? 'Свернуть' : 'Развернуть',
                style: CustomTextStyle.red15,
              ),
            ),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Услуга помощи погрузки / разгрузки',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        additional1 = !additional1;
                        additional1Controller.add(additional1);
                        additionalController.add(additional);
                      },
                      icon: additional1
                          ? const Icon(Icons.keyboard_arrow_up)
                          : const Icon(Icons.keyboard_arrow_down),
                      splashRadius: 15,
                    )
                  ],
                ),
                const Text(
                  'Егорка поможет вам загрузить/разгрузить посылку. Если вес посылки превышает бесплатные нормы и Егорка физически не сможет загрузить/разгрузить один, то Егорка вправе попросить отправителя/получателя о помощи.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                StreamBuilder<bool>(
                  stream: additional1Controller.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    additional1 = snapshot.data!;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: additional1 ? 175.h : 0.h,
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Row(
                            children: const [
                              Text(
                                'Какой вес? (кг)',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          StreamBuilder<int>(
                            stream: weightControllerSlider.stream,
                            initialData: 0,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      focusNode: weigthFocus,
                                      height: 45.h,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      fillColor: Colors.white,
                                      hintText: '0',
                                      onFieldSubmitted: (value) => calc(),
                                      textInputType: TextInputType.number,
                                      onChanged: (value) {
                                        int? res = int.tryParse(value);
                                        if (res != null) {
                                          weightControllerSlider.add(res);
                                        } else {
                                          weightControllerSlider.add(0);
                                        }
                                      },
                                      formatters: [
                                        CustomInputFormatterSlider(maxSlider)
                                      ],
                                      textEditingController: weigthController,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    flex: 2,
                                    child: Slider(
                                      min: minSlider,
                                      max: maxSlider,
                                      activeColor: Colors.red,
                                      inactiveColor: Colors.grey[300],
                                      thumbColor: Colors.white,
                                      value: snapshot.data!.toDouble(),
                                      onChangeEnd: (value) => calc(),
                                      onChanged: (value) {
                                        weightControllerSlider
                                            .add(value.toInt());
                                        weigthController.text =
                                            value.toInt().toString();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: const [
                              Text(
                                'Какие размеры? (см)',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              const Text('Ширина'),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: CustomTextField(
                                  onFieldSubmitted: (value) => calc(),
                                  focusNode: widthFocus,
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  fillColor: Colors.white,
                                  hintText: '0',
                                  textInputType: TextInputType.number,
                                  textEditingController: widthController,
                                ),
                              ),
                              const Text('Высота'),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: CustomTextField(
                                  onFieldSubmitted: (value) => calc(),
                                  focusNode: heightFocus,
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  fillColor: Colors.white,
                                  hintText: '0',
                                  textInputType: TextInputType.number,
                                  textEditingController: heightController,
                                ),
                              ),
                              const Text('Глубина'),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: CustomTextField(
                                  onFieldSubmitted: (value) => calc(),
                                  focusNode: depthFocus,
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  fillColor: Colors.white,
                                  hintText: '0',
                                  textInputType: TextInputType.number,
                                  textEditingController: depthController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 5.w),
                Row(
                  children: [
                    const Text(
                      'Отвезти посылку на почту',
                      style: CustomTextStyle.grey15bold,
                    ),
                    IconButton(
                      onPressed: () {
                        additional2 = !additional2;
                        additional2Controller.add(additional2);
                        additionalController.add(additional);
                      },
                      icon: additional2
                          ? const Icon(Icons.keyboard_arrow_up)
                          : const Icon(Icons.keyboard_arrow_down),
                      splashRadius: 15,
                    )
                  ],
                ),
                SizedBox(height: 5.w),
                const Text(
                  'Егорка отвезет посылку на почту и отправит её по указанному ниже адресу. Если вы хотите получить оригинал квитанции, то укажите дополнительную точку в заказе. Дополнительные расходы за отправку спишутся с вашей банковской карты или депозита.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: additional2 ? 150.h : 0.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'На какой адрес отправить?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whereFocus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: аэропорт Шереметьево',
                          textEditingController: whereToSend,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'На кого?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whoFocus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Иванов Иван Иванович',
                          textEditingController: whoToSend,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Отправить посылку поездом, автобусом или самолетом',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        additional3 = !additional3;
                        additional3Controller.add(additional3);
                        additionalController.add(additional);
                      },
                      icon: additional3
                          ? const Icon(Icons.keyboard_arrow_up)
                          : const Icon(Icons.keyboard_arrow_down),
                      splashRadius: 15,
                    )
                  ],
                ),
                SizedBox(height: 15.w),
                const Text(
                  'Егорка заранее приедет на вокзал, найдет ваш поезд/автобус, рейс и отправит строго по указанному вами поручению. Дополнительные расходы (за отправку, парковку и т.д.) спишутся с вашей банковской карты или депозита, только после согласования с оператором.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: additional3 ? 315.h : 0.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Откуда отправление?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whereDeparture1Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: аэропорт Шереметьево',
                          textEditingController: whereDeparture1,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Кому отдать?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whoDeparture1Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: Стойка 16 авиакомпании',
                          textEditingController: whoDeparture1,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Номер рейса/поезда/автобуса?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: numberDeparture1Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: аэропот Шереметьево',
                          textEditingController: numberDeparture1,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Контакты представителя?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: contactDeparture1Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'В формате: +79998887766',
                          textEditingController: contactDeparture1,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Встретить посылку поездом, автобусом или самолетом',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        additional4 = !additional4;
                        additional4Controller.add(additional4);
                        additionalController.add(additional);
                      },
                      icon: additional4
                          ? const Icon(Icons.keyboard_arrow_up)
                          : const Icon(Icons.keyboard_arrow_down),
                      splashRadius: 15,
                    )
                  ],
                ),
                SizedBox(height: 5.w),
                const Text(
                  'Егорка заранее приедет на вокзал, встретит ваш поезд/автобус, рейс и заберет вашу посылку. После чего доставит на указанный вами адрес. Дополнительные расходы (к примеру, парковку) спишутся с вашей банковской карты или депозита, только после согласования с оператором.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: additional4 ? 315.h : 0.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Куда прибывает?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whereDeparture2Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: аэропорт Шереметьево',
                          textEditingController: whereDeparture2,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'У кого забрать?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: whoDeparture2Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: Стойка 16 авиакомпании',
                          textEditingController: whoDeparture2,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Номер рейса/поезда/автобуса?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: numberDeparture2Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Например: аэропот Шереметьево',
                          textEditingController: numberDeparture2,
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: const [
                            Text(
                              'Контакты представителя?',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        CustomTextField(
                          onFieldSubmitted: (value) => calc(),
                          focusNode: contactDeparture2Focus,
                          height: 45.h,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.w),
                          hintStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'В формате: +79998887766',
                          textEditingController: contactDeparture2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      attorney = !attorney;
                    });
                    calc();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: attorney,
                        fillColor: MaterialStateProperty.all(Colors.red),
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          setState(() {
                            attorney = !attorney;
                          });
                          calc();
                        },
                      ),
                      const Text(
                        'ОФОРМЛЕНИЕ ДОВЕРЕННОСТИ',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                const Text(
                  'После оформления заказа, Егорка пришлет вам в СМС или WhatsApp паспортные данные (ФИО, серия и номер паспорта, дата выдачи, где и когда выдан) для составления доверенности. Если нужные дополнительные данные, то укажите их ниже в поручении для Егорки.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      industrialZone = !industrialZone;
                    });
                    calc();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: industrialZone,
                        fillColor: MaterialStateProperty.all(Colors.red),
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          setState(() {
                            industrialZone = !industrialZone;
                          });
                          calc();
                        },
                      ),
                      const Text(
                        'Промзона',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                const Text(
                  'В том случае, если вы не сможете выдать пропуск Егорке для заезда на территорию промзоны. Егорка припаркует свой автомобиль за воротами и пешком доставит посылку получателю.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      toDoor = !toDoor;
                    });
                    calc();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: toDoor,
                        fillColor: MaterialStateProperty.all(Colors.red),
                        shape: const CircleBorder(),
                        // onChanged: (value) {},
                        onChanged: (value) {
                          setState(() {
                            toDoor = !toDoor;
                          });
                          calc();
                        },
                      ),
                      const Text(
                        'Доставить до двери',
                        style: CustomTextStyle.grey15bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                const Text(
                  'Егорка доставит вашу посылку до входной двери квартиры/офиса. Если данная услуга не активирована, Егорка встретит получателя возле подъезда.',
                  style: CustomTextStyle.grey14w400,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dismissible(List<PointDetails> points, int index, TypeAdd typeAdd) {
    int num = index;
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: points.length == 1
          ? (direction) {
              return Future.value(false);
            }
          : (direction) {
              points.removeAt(index);
              calc();

              return points.length == 1
                  ? Future.value(false)
                  : Future.value(true);
            },
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: typeAdd == TypeAdd.sender ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(index == 0 ? 15.r : 0),
            bottomRight: Radius.circular(
              index == points.length - 1 ? 15.r : 0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Удалить',
              style: CustomTextStyle.white15w600,
            ),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: points.length == 1
                ? const Radius.circular(15)
                : routeOrderSender.length - 1 == index
                    ? const Radius.circular(15)
                    : Radius.zero,
            bottomRight: points.length == 1
                ? const Radius.circular(15)
                : points.length - 1 == index
                    ? const Radius.circular(15)
                    : Radius.zero,
            topLeft: points.length == 1
                ? const Radius.circular(15)
                : points.length - 1 == index
                    ? Radius.zero
                    : index == 0
                        ? const Radius.circular(15)
                        : Radius.zero,
            topRight: points.length == 1
                ? const Radius.circular(15)
                : points.length - 1 == index
                    ? Radius.zero
                    : index == 0
                        ? const Radius.circular(15)
                        : Radius.zero,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  typeAdd == TypeAdd.sender
                      ? 'assets/images/from.png'
                      : 'assets/images/to.png',
                  height: 25.h,
                ),
                SizedBox(width: 15.w),
                Flexible(
                  child: Text(
                    points[index].suggestions.name,
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(
                  typeAdd == TypeAdd.sender
                      ? Icons.arrow_downward_rounded
                      : Icons.flag,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () async {
                    dynamic details = await Navigator.of(context)
                        .pushNamed(AppRoute.detailsOrder, arguments: [
                      typeAdd,
                      ++num,
                      points[index],
                    ]);

                    points[index] = details!;

                    calc();
                  },
                  child: Text(
                    'Указать детали',
                    style: CustomTextStyle.red15
                        .copyWith(fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void calc() {
    List<Ancillaries> ancillaries = [];
    if (weigthController.text.isNotEmpty ||
        widthController.text.isNotEmpty ||
        heightController.text.isNotEmpty ||
        depthController.text.isNotEmpty) {
      ancillaries.add(
        Ancillaries(
          'Load',
          Params(
            weight: weigthController.text,
            width: widthController.text,
            height: heightController.text,
            depth: depthController.text,
          ),
        ),
      );
    }
    if (whereToSend.text.isNotEmpty || whoToSend.text.isNotEmpty) {
      ancillaries.add(
        Ancillaries(
          'Post',
          Params(
            name: whereToSend.text,
            address: whoToSend.text,
          ),
        ),
      );
    }
    if (toDoor) {
      ancillaries.add(
        Ancillaries(
          'DoorToDoor',
          Params(),
        ),
      );
    }
    if (attorney) {
      ancillaries.add(
        Ancillaries(
          'Proxy',
          Params(),
        ),
      );
    }
    if (industrialZone) {
      ancillaries.add(
        Ancillaries(
          'Industrial',
          Params(),
        ),
      );
    }
    if (coastController.text.isNotEmpty) {
      ancillaries.add(
        Ancillaries(
          'Insurance',
          Params(amount: int.parse(coastController.text) * 100),
        ),
      );
    }
    if (whereDeparture1.text.isNotEmpty ||
        whoDeparture1.text.isNotEmpty ||
        numberDeparture1.text.isNotEmpty ||
        contactDeparture1.text.isNotEmpty) {
      ancillaries.add(
        Ancillaries(
          'TrainSend',
          Params(
            point: whereDeparture1.text,
            number: numberDeparture1.text,
            name: whoDeparture1.text,
            phone: contactDeparture1.text,
          ),
        ),
      );
    }
    if (whereDeparture2.text.isNotEmpty ||
        whoDeparture2.text.isNotEmpty ||
        numberDeparture2.text.isNotEmpty ||
        contactDeparture2.text.isNotEmpty) {
      ancillaries.add(
        Ancillaries(
          'TrainReceive',
          Params(
            point: whereDeparture2.text,
            number: numberDeparture2.text,
            name: whoDeparture2.text,
            phone: contactDeparture2.text,
          ),
        ),
      );
    }

    BlocProvider.of<NewOrderPageBloc>(context).add(
      CalculateCoastEvent(
        time,
        routeOrderSender,
        routeOrderReceiver,
        listChoice.first.type,
        ancillaries,
        documentController.text,
        coasts != null ? coasts!.result!.id : null,
      ),
    );
  }

  void showDateTime() async {
    time = null;

    DateTime initialData =
        DateTime.now().add(const Duration(hours: 2, minutes: 1));
    if (Platform.isAndroid) {
      final value = await showDialog(
          context: context,
          builder: (context) {
            return DatePickerDialog(
              initialDate: DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(2030),
            );
          });
      if (value != null) {
        final TimeOfDay? timePicked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour,
            minute: TimeOfDay.now().minute,
          ),
        );
        final DateTime temp = DateTime(
          value.year,
          value.month,
          value.day,
          timePicked != null ? timePicked.hour : 0,
          timePicked != null ? timePicked.minute : 0,
        );
        startOrderController.text =
            DateFormat('dd.MM.yyyy  HH:MM:ss').format(temp);
        time = temp;
      }
    } else {
      showDialog(
        useSafeArea: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () {
                              if (time == null) {
                                time = initialData;
                                startOrderController.text =
                                    DateFormat('dd.MM.yyyy  HH:mm')
                                        .format(time!);
                              }
                              Navigator.of(ctx).pop();
                              calc();
                            },
                            child: const Text(
                              'Готово',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200.h,
                      color: Colors.grey[200],
                      child: CupertinoDatePicker(
                        minimumYear: DateTime.now().year,
                        initialDateTime: initialData,
                        minimumDate: initialData,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        use24hFormat: true,
                        onDateTimeChanged: (value) {
                          startOrderController.text =
                              DateFormat('dd.MM.yyyy HH:mm').format(value);
                          time = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
