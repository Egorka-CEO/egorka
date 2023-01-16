import 'dart:async';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/cargos.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/model/point_marketplace.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/widget/bottom_sheet_marketplace.dart';
import 'package:egorka/widget/calculate_circular.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_slider.dart';
import 'package:egorka/widget/load_form.dart';
import 'package:egorka/widget/total_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MarketPage extends StatelessWidget {
  int? recordPIN, recorNumber;
  MarketPage({super.key, this.recordPIN, this.recorNumber});
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MarketPlacePageBloc>(
            create: (context) => MarketPlacePageBloc(),
          ),
        ],
        child: MarketPages(recorNumber: recorNumber, recordPIN: recordPIN),
      ),
    );
  }
}

class MarketPages extends StatefulWidget {
  int? recordPIN, recorNumber;
  MarketPages({super.key, this.recordPIN, this.recorNumber});

  @override
  State<MarketPages> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPages>
    with TickerProviderStateMixin {
  bool details = false;
  bool additional = false;
  bool additional1 = false;
  bool additional2 = false;
  TypeAdd? typeAdd;
  Suggestions? suggestion;
  PointMarketPlace? points;
  CoastResponse? coast;
  DateTime? time;
  InfoForm? formOrder;
  bool loadOrder = false;
  int indexTab = 0;
  String? errorAddress;
  double minSlider = 0;
  double maxSlider = 25;

  // TextEditingController controller = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController item1Controller = TextEditingController();
  TextEditingController item2Controller = TextEditingController();
  TextEditingController item3Controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController startOrderController = TextEditingController();
  TextEditingController countBucketController = TextEditingController();
  TextEditingController countPalletController = TextEditingController();
  TextEditingController countPalletControllerMore = TextEditingController();
  TextEditingController countPalletControllerMore15kg = TextEditingController();
  TextEditingController countPalletControllerLess15kg = TextEditingController();
  TextEditingController controllerBtmSheet = TextEditingController();

  PanelController panelController = PanelController();
  ScrollController scrollController = ScrollController();

  final countBucket = StreamController<int>();
  final countPallet = StreamController<int>();
  final detailsController = StreamController<bool>();
  final bucketCountLess15kg = StreamController<int>();
  final bucketCountMore15kg = StreamController<int>();
  final additionalController = StreamController<bool>();
  final additional1Controller = StreamController<bool>();
  final additional2Controller = StreamController<bool>();

  final FocusNode contactFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode bucketFocus = FocusNode();
  final FocusNode palletFocus = FocusNode();
  final FocusNode podFocus = FocusNode();
  final FocusNode etajFocus = FocusNode();
  final FocusNode officeFocus = FocusNode();
  final FocusNode bucketFocusLess15kg = FocusNode();
  final FocusNode bucketFocusMore15kg = FocusNode();
  final FocusNode palletFocusAdditional = FocusNode();
  late TabController tabController;

  @override
  void dispose() {
    countBucket.close();
    countPallet.close();
    detailsController.close();
    bucketCountLess15kg.close();
    bucketCountMore15kg.close();
    additionalController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    if (widget.recorNumber != null && widget.recordPIN != null) {
      loadOrder = true;
      getForm();
    }
  }

  void getForm() async {
    formOrder = await Repository()
        .infoForm(widget.recorNumber.toString(), widget.recordPIN.toString());
    suggestion = Suggestions(
        iD: '', name: '', point: formOrder!.result!.locations!.first.point);
    fromController.text = formOrder!.result!.locations!.first.point!.address!;
    toController.text = formOrder!.result!.locations!.last.point!.address!;
    startOrderController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    nameController.text = formOrder!.result!.locations!.first.contact!.name!;
    phoneController.text =
        formOrder!.result!.locations!.first.contact!.phoneMobile!;

    points =
        PointMarketPlace(code: formOrder!.result!.locations!.last.point!.code);

    calcOrder();

    setState(() {});
  }

  void _findMe() async {
    if (await LocationGeo().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      checkPosition(position.latitude, position.longitude);
    }
  }

  void checkPosition(double latitude, double longitude) async {
    List<geo.Placemark> placemarks = await geo
        .placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'ru');

    String address = '';

    if (placemarks.first.street!.isNotEmpty) {
      address += placemarks.first.street!;
      if (placemarks.first.locality!.isNotEmpty) {
        address += ', г.${placemarks.first.locality!}';
      }
    } else {
      address = placemarks.first.locality!;
    }

    fromController.text = address;
    suggestion = Suggestions(
      iD: '',
      name: address,
      point: Point(
        address: address,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    if (placemarks.first.subThoroughfare!.isEmpty) {
      errorAddress = 'Ошибка: Укажите номер дома';
    } else {
      errorAddress = null;
    }
    setState(() {});

    calcOrder();
  }

  @override
  Widget build(BuildContext context) {
    bool keyBoardVisible = MediaQuery.of(context).viewInsets.bottom == 0;
    return Builder(
      builder: (context) {
        BlocProvider.of<MarketPlacePageBloc>(context).add(GetMarketPlaces());
        return Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
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
                                child: const Text(
                                  'Отмена',
                                  style: CustomTextStyle.red15,
                                ),
                              ),
                              Align(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PopupMenuButton<String>(
                                      tooltip: 'Способ доставки',
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            value: 'test',
                                            child: Text(
                                              'Экспресс',
                                              style:
                                                  CustomTextStyle.black15w500,
                                            ),
                                          )
                                        ];
                                      },
                                      child: Row(
                                        children: const [
                                          Text(
                                            'Доставка до маркетплейса',
                                            style: CustomTextStyle.black15w500,
                                          ),
                                          Icon(Icons.keyboard_arrow_down),
                                        ],
                                      ),
                                      onSelected: (v) {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
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
          body: loadOrder && formOrder == null
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
                      buildWhen: (previous, current) {
                        if (current is MarketPlaceStateCloseBtmSheet) {
                          suggestion = current.address;
                          errorAddress = null;
                          if (typeAdd != null && typeAdd == TypeAdd.sender) {
                            fromController.text = suggestion!.name;
                          } else if (typeAdd != null &&
                              typeAdd == TypeAdd.receiver) {
                            toController.text = suggestion!.name;
                          }
                          calcOrder();
                        } else if (current is MarketPlacesSuccessState) {
                          coast = current.coastResponse;
                        } else if (current is CreateFormSuccess) {
                          BlocProvider.of<HistoryOrdersBloc>(context)
                              .add(GetListOrdersEvent());
                          MessageDialogs()
                              .completeDialog(text: 'Заявка создана')
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        } else if (current is CreateFormFail) {
                          String errors = '';
                          for (var element in coast!.errors!) {
                            errors +=
                                '${element.messagePrepend!}${element.message!}\n';
                          }
                          MessageDialogs()
                              .errorDialog(text: 'Отклонено', error: errors);
                        }
                        return true;
                      },
                      builder: (context, snapshot) {
                        return Expanded(
                          child: Stack(
                            children: [
                              ListView(
                                physics: const ClampingScrollPhysics(),
                                controller: scrollController,
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 15.h),
                                        const Text(
                                          'Как это работает?',
                                          style: CustomTextStyle.red15,
                                        ),
                                        SizedBox(height: 20.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13.r),
                                            color: Colors.white,
                                          ),
                                          child: TabBar(
                                            unselectedLabelColor: Colors.black,
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              color: Colors.red,
                                            ),
                                            onTap: (value) {
                                              indexTab = value;
                                              setState(() {});
                                              calcOrder();
                                            },
                                            splashBorderRadius:
                                                BorderRadius.circular(20),
                                            controller: tabController,
                                            tabs: [
                                              SizedBox(
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    'FBO',
                                                    style: CustomTextStyle
                                                        .grey15bold
                                                        .copyWith(
                                                            color: indexTab == 0
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    'FBS',
                                                    style: CustomTextStyle
                                                        .grey15bold
                                                        .copyWith(
                                                            color: indexTab == 0
                                                                ? Colors.black
                                                                : Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            const Text(
                                              'Откуда забрать?',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        if (errorAddress != null)
                                          Row(
                                            children: [
                                              SizedBox(width: 5.w),
                                              Text(
                                                errorAddress!,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                    value: false,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                    shape: const CircleBorder(),
                                                    onChanged: (value) {},
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        controllerBtmSheet
                                                                .text =
                                                            fromController.text;
                                                        typeAdd =
                                                            TypeAdd.sender;
                                                        BlocProvider.of<
                                                                    MarketPlacePageBloc>(
                                                                context)
                                                            .add(
                                                                MarketPlaceOpenBtmSheet());
                                                        panelController
                                                            .animatePanelToPosition(
                                                          1,
                                                          curve: Curves
                                                              .easeInOutQuint,
                                                          duration:
                                                              const Duration(
                                                            milliseconds: 1000,
                                                          ),
                                                        );
                                                      },
                                                      child: CustomTextField(
                                                        height: 45.h,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        fillColor: Colors.white,
                                                        enabled: false,
                                                        hintText: '',
                                                        textEditingController:
                                                            fromController,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  GestureDetector(
                                                    onTap: _findMe,
                                                    child: const Icon(
                                                      Icons.gps_fixed,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        GestureDetector(
                                          onTap: () =>
                                              detailsController.add(!details),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 5.w),
                                              const Text(
                                                'Указать детали',
                                                style: CustomTextStyle.red15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        StreamBuilder<bool>(
                                            stream: detailsController.stream,
                                            initialData: false,
                                            builder: (context, snapshot) {
                                              details = snapshot.data!;
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                height:
                                                    snapshot.data! ? 85.h : 0.h,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    5.w),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Не обязательно к заполнению',
                                                              style: CustomTextStyle
                                                                  .grey15bold
                                                                  .copyWith(
                                                                      color: Colors
                                                                              .grey[
                                                                          500]),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 30.h),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  CustomTextField(
                                                                height: 45.h,
                                                                focusNode:
                                                                    podFocus,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.w),
                                                                hintText:
                                                                    'Подъезд',
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                textEditingController:
                                                                    item1Controller,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 15.w),
                                                            Expanded(
                                                              child:
                                                                  CustomTextField(
                                                                height: 45.h,
                                                                focusNode:
                                                                    etajFocus,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                hintText:
                                                                    'Этаж',
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.w),
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                textEditingController:
                                                                    item2Controller,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 15.w),
                                                            Expanded(
                                                              child:
                                                                  CustomTextField(
                                                                height: 45.h,
                                                                focusNode:
                                                                    officeFocus,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                hintText:
                                                                    'Офис/кв.',
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.w),
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                textEditingController:
                                                                    item3Controller,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            const Text(
                                              'Куда отвезти?',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: false,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue),
                                                    shape: const CircleBorder(),
                                                    onChanged: (value) {},
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        final marketplaces =
                                                            BlocProvider.of<
                                                                        MarketPlacePageBloc>(
                                                                    context)
                                                                .marketPlaces;
                                                        if (marketplaces !=
                                                            null) {
                                                          toController.text =
                                                              marketplaces
                                                                  .result
                                                                  .points
                                                                  .first
                                                                  .name!
                                                                  .first
                                                                  .name!;
                                                          points = marketplaces
                                                              .result.points[0];
                                                          showMarketPlaces(
                                                              marketplaces);
                                                        }
                                                      },
                                                      child: CustomTextField(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        height: 45.h,
                                                        fillColor: Colors.white,
                                                        enabled: false,
                                                        hintText: '',
                                                        textEditingController:
                                                            toController,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final marketplaces =
                                                          BlocProvider.of<
                                                                      MarketPlacePageBloc>(
                                                                  context)
                                                              .marketPlaces;
                                                      if (marketplaces !=
                                                          null) {
                                                        final result = await Navigator
                                                                .of(context)
                                                            .pushNamed(
                                                                AppRoute
                                                                    .marketplacesMap,
                                                                arguments:
                                                                    marketplaces);
                                                        if (result != null) {
                                                          final pointsRes = result
                                                              as PointMarketPlace;
                                                          toController.text =
                                                              pointsRes.name!
                                                                  .first.name!;

                                                          points = pointsRes;

                                                          calcOrder();
                                                        }
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.map_outlined,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                ],
                                              ),
                                            ],
                                          ),
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
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15.w),
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
                                                    fillColor: Colors.white,
                                                    hintText: '',
                                                    enabled: false,
                                                    textEditingController:
                                                        startOrderController,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              const Icon(
                                                Icons.help_outline_outlined,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10.w),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            const Expanded(
                                              child: Text(
                                                'Оформить доставку до Маркетплейса на завтра можно строго до 15:00.',
                                                style: CustomTextStyle.grey15,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            const Text(
                                              'Ваши контакты',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                onFieldSubmitted: (value) =>
                                                    calcOrder(),
                                                maxLines: 1,
                                                height: 45.h,
                                                focusNode: contactFocus,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.w),
                                                fillColor: Colors.white,
                                                hintText: 'Имя',
                                                hintStyle: CustomTextStyle
                                                    .textHintStyle,
                                                textEditingController:
                                                    nameController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                onFieldSubmitted: (value) =>
                                                    calcOrder(),
                                                focusNode: phoneFocus,
                                                height: 45.h,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.w),
                                                fillColor: Colors.white,
                                                hintText: '+7 (999) 888-77-66',
                                                textInputType:
                                                    TextInputType.number,
                                                textEditingController:
                                                    phoneController,
                                                formatters: [
                                                  MaskTextInputFormatter(
                                                    mask: '+7 (###) ###-##-##',
                                                    filter: {
                                                      "#": RegExp(r'[0-9]')
                                                    },
                                                  )
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
                                              'Кол-во коробок?',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        StreamBuilder<int>(
                                          stream: countBucket.stream,
                                          initialData: 0,
                                          builder: (context, snapshot) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: CustomTextField(
                                                    onTap: () => scrolling(),
                                                    onFieldSubmitted: (value) =>
                                                        calcOrder(),
                                                    onChanged: (value) {
                                                      int? res =
                                                          int.tryParse(value);
                                                      if (res != null) {
                                                        countBucket.add(res);
                                                      } else {
                                                        countBucket.add(0);
                                                      }
                                                    },
                                                    focusNode: bucketFocus,
                                                    height: 45.h,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    fillColor: Colors.white,
                                                    hintText: '0',
                                                    textInputType:
                                                        TextInputType.number,
                                                    formatters: [
                                                      CustomInputFormatterSlider(
                                                          maxSlider)
                                                    ],
                                                    textEditingController:
                                                        countBucketController,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                const Icon(
                                                  Icons.help_outline_outlined,
                                                  color: Colors.red,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: minSlider,
                                                    max: maxSlider,
                                                    activeColor: Colors.red,
                                                    inactiveColor:
                                                        Colors.grey[300],
                                                    thumbColor: Colors.white,
                                                    value: snapshot.data!
                                                        .toDouble(),
                                                    onChangeEnd: (value) =>
                                                        calcOrder(),
                                                    onChanged: (value) {
                                                      countBucket
                                                          .add(value.toInt());
                                                      countBucketController
                                                              .text =
                                                          value
                                                              .toInt()
                                                              .toString();
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            const Text(
                                              'Кол-во паллет?',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        StreamBuilder<int>(
                                          stream: countPallet.stream,
                                          initialData: 0,
                                          builder: (context, snapshot) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: CustomTextField(
                                                    onTap: () => scrolling(),
                                                    onFieldSubmitted: (value) =>
                                                        calcOrder(),
                                                    onChanged: (value) {
                                                      int? res =
                                                          int.tryParse(value);
                                                      if (res != null) {
                                                        countPallet.add(res);
                                                      } else {
                                                        countPallet.add(0);
                                                      }
                                                    },
                                                    maxLines: 1,
                                                    focusNode: palletFocus,
                                                    height: 45.h,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    fillColor: Colors.white,
                                                    hintText: '0',
                                                    textInputType:
                                                        TextInputType.number,
                                                    formatters: [
                                                      CustomInputFormatterSlider(
                                                          maxSlider)
                                                    ],
                                                    textEditingController:
                                                        countPalletController,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                const Icon(
                                                  Icons.help_outline_outlined,
                                                  color: Colors.red,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: minSlider,
                                                    max: maxSlider,
                                                    activeColor: Colors.red,
                                                    inactiveColor:
                                                        Colors.grey[300],
                                                    thumbColor: Colors.white,
                                                    value: snapshot.data!
                                                        .toDouble(),
                                                    onChangeEnd: (value) =>
                                                        calcOrder(),
                                                    onChanged: (value) {
                                                      countPallet
                                                          .add(value.toInt());
                                                      countPalletController
                                                              .text =
                                                          value
                                                              .toInt()
                                                              .toString();
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(height: 20.h),
                                        StreamBuilder<bool>(
                                          stream: additionalController.stream,
                                          initialData: false,
                                          builder: (context, snapshot) {
                                            additional = snapshot.data!;

                                            double height;
                                            if (additional) {
                                              height = 335.h;
                                              if (additional1) height += 170.h;
                                              if (additional2) height += 90.h;
                                            } else {
                                              height = 0.h;
                                            }
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5.w),
                                                    const Text(
                                                      'Дополнительные услуги',
                                                      style: CustomTextStyle
                                                          .grey15bold,
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        additionalController
                                                            .add(!additional);
                                                        if (!additional) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      100), () {
                                                            scrollController.animateTo(
                                                                350.h,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                curve: Curves
                                                                    .linear);
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        additional
                                                            ? 'Свернуть'
                                                            : 'Развернуть',
                                                        style: CustomTextStyle
                                                            .red15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  height: height,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.w),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 10.h),
                                                              StreamBuilder<
                                                                  bool>(
                                                                stream:
                                                                    additional1Controller
                                                                        .stream,
                                                                initialData:
                                                                    false,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  additional1 =
                                                                      snapshot
                                                                          .data!;
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          const Flexible(
                                                                            child:
                                                                                Text(
                                                                              'Услуга помощи погрузки / разгрузки',
                                                                              style: CustomTextStyle.grey15bold,
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              additional1 = !additional1;
                                                                              additional1Controller.add(additional1);
                                                                              additionalController.add(additional);
                                                                            },
                                                                            icon: additional1
                                                                                ? const Icon(Icons.keyboard_arrow_up)
                                                                                : const Icon(Icons.keyboard_arrow_down),
                                                                            splashRadius:
                                                                                15,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Text(
                                                                        'Если вы не хотите пачкать руки и предпочитаете наблюдать за чужой работой - закажите эту услугу. Егорка заберет коробки с вашего склада и погрузит их в свой авто. Если нужно - погрузит на паллету и запаллетирует (выберите услугу ниже).',
                                                                        style: CustomTextStyle
                                                                            .grey14w400,
                                                                        textAlign:
                                                                            TextAlign.justify,
                                                                      ),
                                                                      AnimatedContainer(
                                                                        duration:
                                                                            const Duration(milliseconds: 100),
                                                                        height: snapshot.data!
                                                                            ? 170.h
                                                                            : 0.h,
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(height: 10.h),
                                                                                Row(
                                                                                  children: const [
                                                                                    Text('Кол-во коробок до 15 кг?')
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5.h),
                                                                                StreamBuilder<int>(
                                                                                    stream: bucketCountLess15kg.stream,
                                                                                    initialData: 0,
                                                                                    builder: (context, snapshot) {
                                                                                      return Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: CustomTextField(
                                                                                              onTap: () => scrolling(),
                                                                                              onFieldSubmitted: (value) => calcOrder(),
                                                                                              onChanged: (value) {
                                                                                                int? res = int.tryParse(value);
                                                                                                if (res != null) {
                                                                                                  bucketCountLess15kg.add(res);
                                                                                                } else {
                                                                                                  bucketCountLess15kg.add(0);
                                                                                                }
                                                                                              },
                                                                                              focusNode: bucketFocusLess15kg,
                                                                                              height: 45.h,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                                                              fillColor: Colors.white,
                                                                                              hintText: '0',
                                                                                              textInputType: TextInputType.number,
                                                                                              formatters: [
                                                                                                CustomInputFormatterSlider(maxSlider)
                                                                                              ],
                                                                                              textEditingController: countPalletControllerLess15kg,
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
                                                                                              onChangeEnd: (value) => calcOrder(),
                                                                                              onChanged: (value) {
                                                                                                bucketCountLess15kg.add(value.toInt());
                                                                                                countPalletControllerLess15kg.text = value.toInt().toString();
                                                                                              },
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    }),
                                                                                SizedBox(height: 15.w),
                                                                                Row(
                                                                                  children: const [
                                                                                    Text('Кол-во коробок свыше 15 кг?'),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5.h),
                                                                                StreamBuilder<int>(
                                                                                    stream: bucketCountMore15kg.stream,
                                                                                    initialData: 0,
                                                                                    builder: (context, snapshot) {
                                                                                      return Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: CustomTextField(
                                                                                              onTap: () => scrolling(),
                                                                                              onFieldSubmitted: (value) => calcOrder(),
                                                                                              onChanged: (value) {
                                                                                                int? res = int.tryParse(value);
                                                                                                if (res != null) {
                                                                                                  bucketCountMore15kg.add(res);
                                                                                                } else {
                                                                                                  bucketCountMore15kg.add(0);
                                                                                                }
                                                                                              },
                                                                                              focusNode: bucketFocusMore15kg,
                                                                                              height: 45.h,
                                                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                                                              fillColor: Colors.white,
                                                                                              hintText: '0',
                                                                                              textInputType: TextInputType.number,
                                                                                              formatters: [
                                                                                                CustomInputFormatterSlider(maxSlider)
                                                                                              ],
                                                                                              textEditingController: countPalletControllerMore15kg,
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
                                                                                              onChangeEnd: (value) => calcOrder(),
                                                                                              onChanged: (value) {
                                                                                                bucketCountMore15kg.add(value.toInt());
                                                                                                countPalletControllerMore15kg.text = value.toInt().toString();
                                                                                              },
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    }),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              StreamBuilder<
                                                                  bool>(
                                                                stream:
                                                                    additional2Controller
                                                                        .stream,
                                                                initialData:
                                                                    false,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  additional2 =
                                                                      snapshot
                                                                          .data!;
                                                                  return Stack(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              const Text(
                                                                                'Паллетирование',
                                                                                style: CustomTextStyle.grey15bold,
                                                                              ),
                                                                              IconButton(
                                                                                onPressed: () {
                                                                                  additional2 = !additional2;
                                                                                  additional2Controller.add(additional2);
                                                                                  additionalController.add(additional);
                                                                                },
                                                                                icon: additional2 ? const Icon(Icons.keyboard_arrow_up) : const Icon(Icons.keyboard_arrow_down),
                                                                                splashRadius: 15,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const Text(
                                                                            'Егорка приедет к вам с паллетой и стрейч-пленкой. Самостоятельно запаллетирует ваш груз и отправится доставлять ваш товар. Если груз отправляется с нашего склада, то кладовщики разместят ваши коробки на паллету и погрузят водителю в кузов.',
                                                                            style:
                                                                                CustomTextStyle.grey14w400,
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5.w),
                                                                          AnimatedContainer(
                                                                            duration:
                                                                                const Duration(milliseconds: 100),
                                                                            height: snapshot.data!
                                                                                ? 90.h
                                                                                : 0.h,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(height: 15.w),
                                                                                Row(
                                                                                  children: const [
                                                                                    Text('Количество паллет?')
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5.h),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: CustomTextField(
                                                                                        onTap: () => scrolling(),
                                                                                        onFieldSubmitted: (value) => calcOrder(),
                                                                                        focusNode: palletFocusAdditional,
                                                                                        height: 45.h,
                                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                                                                        fillColor: Colors.white,
                                                                                        hintText: '0',
                                                                                        textInputType: TextInputType.number,
                                                                                        textEditingController: countPalletControllerMore,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        keyBoardVisible
                                            ? coast == null
                                                ? SizedBox(height: 50.h)
                                                : SizedBox(height: 220.h)
                                            : SizedBox(height: 400.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (coast != null)
                                TotalPriceWidget(
                                  title: 'Грузовик',
                                  icon: 'assets/images/ic_track.png',
                                  deliveryCost:
                                      (((coast!.result!.totalPrice!.base!)
                                                  .ceil()) /
                                              100)
                                          .ceil()
                                          .toString(),
                                  additionalCost:
                                      (((coast!.result!.totalPrice!.ancillary!)
                                                  .ceil()) /
                                              100)
                                          .ceil()
                                          .toString(),
                                  comissionPaymentSystem: ((double.tryParse(
                                                      coast!.result!.totalPrice!
                                                          .total!)!
                                                  .ceil() *
                                              2.69) /
                                          100)
                                      .ceil()
                                      .toString(),
                                  totalPrice:
                                      '${double.tryParse(coast!.result!.totalPrice!.total!)!.ceil()}',
                                  onTap: () {
                                    if (errorAddress != null) {
                                      MessageDialogs().showAlert(
                                          'Ошибка', 'Укажите номер дома');
                                    } else {
                                      BlocProvider.of<MarketPlacePageBloc>(
                                              context)
                                          .add(CreateForm(coast!.result!.id!));
                                    }
                                  },
                                ),
                              SlidingUpPanel(
                                controller: panelController,
                                renderPanelSheet: false,
                                isDraggable: true,
                                collapsed: Container(),
                                panel: MarketPlaceBottomSheetDraggable(
                                  typeAdd: typeAdd,
                                  fromController: controllerBtmSheet,
                                  panelController: panelController,
                                  onSearch: (sug) {
                                    panelController.animatePanelToPosition(
                                      0,
                                      curve: Curves.easeInOutQuint,
                                      duration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                    );

                                    suggestion = sug;
                                    fromController.text =
                                        suggestion!.point!.address!;
                                    checkPosition(suggestion!.point!.latitude,
                                        suggestion!.point!.longitude);
                                  },
                                ),
                                onPanelClosed: () {},
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
                    ),
                  ],
                ),
        );
      },
    );
  }

  void scrolling() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  void calcOrder() {
    if (suggestion != null && points != null) {
      List<Ancillaries> ancillaries = [];
      ancillaries.add(
        Ancillaries(
          'LoadMarketplace',
          Params(
            count: int.tryParse(countPalletControllerLess15kg.text),
            count15: int.tryParse(countPalletControllerMore15kg.text),
          ),
        ),
      );
      ancillaries.add(
        Ancillaries(
          'Pallet',
          Params(
            count: int.tryParse(countPalletControllerMore.text),
          ),
        ),
      );

      List<Cargos> cargos = [];

      if (countBucketController.text.isNotEmpty) {
        for (int i = 0; i < int.parse(countBucketController.text); i++) {
          cargos.add(Cargos('Box'));
        }
      }
      if (countPalletController.text.isNotEmpty) {
        for (int i = 0; i < int.parse(countPalletController.text); i++) {
          cargos.add(Cargos('Pallet'));
        }
      }

      BlocProvider.of<MarketPlacePageBloc>(context).add(
        CalcOrderMarketplace(
          coast != null ? coast!.result!.id : null,
          suggestion,
          points,
          ancillaries,
          time,
          tabController.index == 0 ? 'Marketplace' : 'FBS',
          nameController.text,
          phoneController.text,
          cargos,
        ),
      );
    }
  }

  void showMarketPlaces(MarketPlaces marketplaces) {
    showCupertinoModalPopup<String>(
      barrierDismissible: false,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        calcOrder();
                      },
                      child: const Text('Готово'),
                    ),
                  ),
                  SizedBox(
                    height: 200.h,
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[200],
                      onSelectedItemChanged: (value) {
                        toController.text =
                            marketplaces.result.points[value].name!.first.name!;
                        points = marketplaces.result.points[value];
                      },
                      itemExtent: 32.0,
                      children: marketplaces.result.points
                          .map((e) => Text(e.name!.first.name!))
                          .toList(),
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

  void showDateTime() async {
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
        startOrderController.text = DateFormat('dd.MM.yyyy HH:mm').format(temp);
        time = temp;
      }
    } else {
      showDialog(
        barrierDismissible: false,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          calcOrder();
                        },
                        child: const Text('Готово'),
                      ),
                    ),
                    Container(
                      height: 200.h,
                      color: Colors.grey[200],
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        onDateTimeChanged: (value) {
                          startOrderController.text =
                              DateFormat('dd.MM.yyyy').format(value);
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

  bool validate() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
