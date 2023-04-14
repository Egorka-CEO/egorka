import 'dart:async';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/cargos.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/contact.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/point.dart' as pointModel;
import 'package:egorka/model/point_marketplace.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/model/type_group.dart';
import 'package:egorka/ui/sidebar/market_place/widget/app_bar.dart';
import 'package:egorka/ui/sidebar/market_place/widget/details_items.dart';
import 'package:egorka/ui/sidebar/market_place/widget/how_it_work.dart';
import 'package:egorka/ui/sidebar/market_place/widget/personal_data.dart';
import 'package:egorka/ui/sidebar/market_place/widget/tab_view.dart';
import 'package:egorka/ui/sidebar/market_place/widget/time_picker.dart';
import 'package:egorka/widget/bottom_sheet_marketplace.dart';
import 'package:egorka/widget/calculate_circular.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_slider.dart';
import 'package:egorka/widget/load_form.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:egorka/widget/total_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MarketPage extends StatelessWidget {
  int? recordPIN, recorNumber;
  CoastResponse? order;
  DeliveryChocie? deliveryChocie;
  Suggestions? start;
  Suggestions? end;
  TypeGroup? typeGroup;

  MarketPage({
    super.key,
    this.recordPIN,
    this.recorNumber,
    this.order,
    this.deliveryChocie,
    this.start,
    this.end,
    this.typeGroup,
  });
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MarketPages(
        recorNumber: recorNumber,
        recordPIN: recordPIN,
        order: order,
        deliveryChocie: deliveryChocie,
        start: start,
        end: end,
        typeGroup: typeGroup,
      ),
    );
  }
}

class MarketPages extends StatefulWidget {
  int? recordPIN, recorNumber;
  CoastResponse? order;
  DeliveryChocie? deliveryChocie;
  Suggestions? start;
  Suggestions? end;
  TypeGroup? typeGroup;
  MarketPages({
    super.key,
    this.recordPIN,
    this.recorNumber,
    this.order,
    this.deliveryChocie,
    this.start,
    this.end,
    this.typeGroup,
  });

  @override
  State<MarketPages> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPages>
    with TickerProviderStateMixin {
  GlobalKey iconBtn = GlobalKey();
  GlobalKey howItWorkKey = GlobalKey();
  GlobalKey whenTakeKey = GlobalKey();
  GlobalKey countBucketKey = GlobalKey();
  GlobalKey countPalletKey = GlobalKey();

  bool details = false;
  bool additional = false;
  bool additional1 = false;
  bool additional2 = false;
  TypeAdd? typeAdd;
  Suggestions? suggestionStart;
  Suggestions? suggestionEnd;
  CoastResponse? coast;
  DateTime? time;
  InfoForm? formOrder;
  bool loadOrder = false;
  int indexTab = 0;
  String? errorAddress;
  double minSliderBucket = 0;
  double maxSliderBucket = 25;
  double minSliderPallet = 0;
  double maxSliderPallet = 33;

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
  final additionalPalletCount = StreamController<int>();
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

  late TypeGroup typeGroup;

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
    typeGroup = widget.typeGroup ?? TypeGroup.fbo;

    if (widget.typeGroup == TypeGroup.fbo) {
      indexTab = 0;
    } else if (widget.typeGroup == TypeGroup.fbs) {
      indexTab = 1;
    } else {
      indexTab = 2;
    }
    tabController =
        TabController(vsync: this, length: 3, initialIndex: indexTab);
    if (widget.recorNumber != null && widget.recordPIN != null) {
      loadOrder = true;
      getForm();
    }
    if (widget.order != null) {
      coast = widget.order;
      typeGroup = widget.typeGroup ?? TypeGroup.fbo;
      suggestionStart = widget.start;
      suggestionEnd = widget.end;

      // tabController =
      //     TabController(vsync: this, length: 3, initialIndex: indexTab);
      fromController.text = widget.start?.name ?? '';
      toController.text = widget.end?.name ?? '';
    }

    phoneFocus.addListener(() {
      if (phoneController.text == '+7 (' && !phoneFocus.hasFocus) {
        phoneController.text = '';
      }
    });
  }

  void getForm() async {
    formOrder = await Repository()
        .infoForm(widget.recorNumber.toString(), widget.recordPIN.toString());
    suggestionStart = Suggestions(
        iD: '', name: '', point: formOrder!.result!.locations!.first.point);
    fromController.text = formOrder!.result!.locations!.first.point!.address!;
    toController.text = formOrder!.result!.locations!.last.point!.address!;
    startOrderController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    nameController.text = formOrder!.result!.locations!.first.contact!.name!;
    phoneController.text =
        formOrder!.result!.locations!.first.contact!.phoneMobile!;

    suggestionEnd = Suggestions(
      iD: null,
      name: formOrder!.result!.locations!.last.point?.address ?? '',
      point: pointModel.Point(
        latitude: formOrder?.result?.locations?.last.point?.latitude,
        longitude: formOrder?.result?.locations?.last.point?.longitude,
      ),
    );

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
    String address = '';

    SearchResultWithSession adress = YandexSearch.searchByPoint(
      point: Point(
        latitude: latitude,
        longitude: longitude,
      ),
      searchOptions: const SearchOptions(),
    );

    final value = await adress.result;

    final house = value.items!.first.toponymMetadata?.address
        .addressComponents[SearchComponentKind.house];

    if (house == null) {
      errorAddress = 'Ошибка: Укажите номер дома';
    } else {
      errorAddress = null;
    }

    address = value.items!.first.name;

    fromController.text = address;

    suggestionStart = Suggestions(
      iD: '',
      name: address,
      point: pointModel.Point(
        address: address,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    setState(() {});

    calcOrder();
  }

  @override
  Widget build(BuildContext context) {
    bool keyBoardVisible = MediaQuery.of(context).viewInsets.bottom == 0;
    return Builder(
      builder: (context) {
        // BlocProvider.of<MarketPlacePageBloc>(context).add(GetMarketPlaces());
        return Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: marketPlaceAppBar(context, iconBtn),
          body: loadOrder && formOrder == null
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
                      buildWhen: (previous, current) {
                        if (current is MarketPlaceStateCloseBtmSheet) {
                          suggestionStart = current.address;
                          errorAddress = null;
                          if (typeAdd != null && typeAdd == TypeAdd.sender) {
                            fromController.text = suggestionStart!.name;
                          } else if (typeAdd != null &&
                              typeAdd == TypeAdd.receiver) {
                            toController.text = suggestionStart!.name;
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
                            Navigator.of(context)
                              ..pop()
                              ..pushNamed(AppRoute.currentOrder, arguments: [
                                current.createFormModel.result.RecordNumber!,
                                current.createFormModel.result.RecordPIN!
                              ]);
                          });
                        } else if (current is CreateFormFail) {
                          String errors = '';
                          for (var element in coast!.errors!) {
                            if (element.message ==
                                'Заказать курьера можно не менее чем через 1 час') {
                              errors +=
                                  'Заказать курьера на завтра можно не позже 15:00 текущего дня.\n';
                            } else {
                              errors +=
                                  '${element.messagePrepend!}${element.message!}\n';
                            }
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
                                        howItWork(context, howItWorkKey),
                                        SizedBox(height: 20.h),
                                        tabGroup(
                                          tabController,
                                          indexTab,
                                          typeGroup,
                                          (value) {
                                            coast = null;
                                            if (indexTab == 2) {
                                              fromController.text = '';
                                              toController.text = '';
                                              suggestionStart = null;
                                              suggestionEnd = null;
                                            }
                                            indexTab = value;
                                            if (value == 0) {
                                              typeGroup = TypeGroup.fbo;
                                            } else if (value == 1) {
                                              typeGroup = TypeGroup.fbs;
                                            } else if (value == 2) {
                                              var bloc = BlocProvider.of<
                                                          SearchAddressBloc>(
                                                      context)
                                                  .marketPlaces;
                                              suggestionStart = null;
                                              suggestionEnd = null;
                                              fromController.text = bloc
                                                      ?.result
                                                      .points[1]
                                                      .name
                                                      ?.first
                                                      .name ??
                                                  '';
                                              toController.text = bloc
                                                      ?.result
                                                      .points[0]
                                                      .name
                                                      ?.first
                                                      .name ??
                                                  '';

                                              typeGroup = TypeGroup.mixfbs;
                                              detailsController.add(false);
                                            }

                                            setState(() {});
                                            calcOrder();
                                          },
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
                                                    MaterialStateProperty.all(
                                                        Colors.red),
                                                shape: const CircleBorder(),
                                                onChanged: (value) {},
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (typeGroup !=
                                                        TypeGroup.mixfbs) {
                                                      controllerBtmSheet.text =
                                                          fromController.text;
                                                      typeAdd = TypeAdd.sender;
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
                                                    }
                                                  },
                                                  child: CustomTextField(
                                                    height: 45.h,
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
                                                    fillColor: Colors.white,
                                                    enabled: false,
                                                    hintText: '',
                                                    textEditingController:
                                                        fromController,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              if (typeGroup != TypeGroup.mixfbs)
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
                                        SizedBox(height: 10.h),
                                        if (typeGroup != TypeGroup.mixfbs)
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
                                            return detailsItems(
                                              details,
                                              item1Controller,
                                              item2Controller,
                                              item3Controller,
                                              podFocus,
                                              etajFocus,
                                              officeFocus,
                                            );
                                          },
                                        ),
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
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: false,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                                shape: const CircleBorder(),
                                                onChanged: (value) {},
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (typeGroup !=
                                                        TypeGroup.mixfbs) {
                                                      final marketplaces =
                                                          BlocProvider.of<
                                                                      SearchAddressBloc>(
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

                                                        suggestionEnd =
                                                            Suggestions(
                                                          iD: null,
                                                          name: marketplaces
                                                                  .result
                                                                  .points[0]
                                                                  .name
                                                                  ?.first
                                                                  .name ??
                                                              '',
                                                          point:
                                                              pointModel.Point(
                                                            latitude:
                                                                marketplaces
                                                                    .result
                                                                    .points[0]
                                                                    .latitude,
                                                            longitude:
                                                                marketplaces
                                                                    .result
                                                                    .points[0]
                                                                    .latitude,
                                                          ),
                                                        );
                                                        showMarketPlaces(
                                                            marketplaces);
                                                      }
                                                    }
                                                  },
                                                  child: CustomTextField(
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
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
                                              if (typeGroup != TypeGroup.mixfbs)
                                                GestureDetector(
                                                  onTap: () async {
                                                    final marketplaces =
                                                        BlocProvider.of<
                                                                    SearchAddressBloc>(
                                                                context)
                                                            .marketPlaces;
                                                    if (marketplaces != null) {
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

                                                        suggestionEnd =
                                                            suggestionEnd =
                                                                Suggestions(
                                                          iD: null,
                                                          name: formOrder!
                                                                  .result!
                                                                  .locations!
                                                                  .last
                                                                  .point
                                                                  ?.address ??
                                                              '',
                                                          point:
                                                              pointModel.Point(
                                                            latitude: pointsRes
                                                                .latitude,
                                                            longitude: pointsRes
                                                                .latitude,
                                                          ),
                                                        );

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
                                        timePicker(
                                          context,
                                          whenTakeKey,
                                          startOrderController,
                                          time,
                                          (value) {
                                            time = value;
                                            calcOrder();
                                          },
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
                                            const Spacer(),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        personalData(
                                          nameController,
                                          phoneController,
                                          contactFocus,
                                          phoneFocus,
                                          (value) {
                                            suggestionStart = Suggestions(
                                              iD: value.id,
                                              name: value.name ?? '',
                                              point: pointModel.Point(
                                                latitude: value.latitude,
                                                longitude: value.longitude,
                                              ),
                                              houseNumber: value.room,
                                            );
                                            fromController.text =
                                                value.address ?? '';
                                            nameController.text =
                                                value.contact?.name ?? '';
                                            phoneController.text =
                                                value.contact?.phoneMobile ??
                                                    '';
                                            calcOrder();
                                          },
                                          () {
                                            calcOrder();
                                          },
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
                                                      countPalletControllerLess15kg
                                                          .text = '';
                                                      countPalletControllerMore15kg
                                                          .text = '';
                                                      bucketCountLess15kg
                                                          .add(0);
                                                      bucketCountMore15kg
                                                          .add(0);
                                                      setState(() {});
                                                      ;
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
                                                          maxSliderBucket)
                                                    ],
                                                    textEditingController:
                                                        countBucketController,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                GestureDetector(
                                                  onTap: () => showTipBucket(
                                                    tabController.index == 0
                                                        ? 'Если у вас больше 10 коробок — заказывайте доставку на паллете.\nИз расчета учитывается 1 коробка = 60х40х40. Если у вас несколько поставок россыпью в разные города, как это часто бывает у МП OZON – оформляйте коробочную доставку указав кол-во мест/коробок. Подробная информация и цены представлены на сайте.'
                                                        : 'Если у вас больше 10 коробок — заказывайте доставку на паллете.\nИз расчета учитывается 1 коробка = 60х40х40. В этот размер вы можете уместить, например, 15 маленьких коробок с каждым товаром. Подробная информация и цены представлены на сайте.',
                                                    context,
                                                    getWidgetPosition(
                                                        countBucketKey),
                                                    (index) {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  child: Icon(
                                                    Icons.help_outline_outlined,
                                                    key: countBucketKey,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: minSliderBucket,
                                                    max: maxSliderBucket,
                                                    activeColor: Colors.red,
                                                    inactiveColor:
                                                        Colors.grey[300],
                                                    thumbColor: Colors.white,
                                                    value: snapshot.data!
                                                        .toDouble(),
                                                    onChangeEnd: (value) =>
                                                        calcOrder(
                                                            loadingAnimation:
                                                                false),
                                                    onChanged: (value) {
                                                      countBucket
                                                          .add(value.toInt());
                                                      countBucketController
                                                              .text =
                                                          value
                                                              .toInt()
                                                              .toString();
                                                      countPalletControllerLess15kg
                                                          .text = '';
                                                      countPalletControllerMore15kg
                                                          .text = '';
                                                      bucketCountLess15kg
                                                          .add(0);
                                                      bucketCountMore15kg
                                                          .add(0);
                                                      setState(() {});
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
                                                      countPalletControllerMore
                                                          .text = '';
                                                      additionalPalletCount
                                                          .add(0);
                                                      setState(() {});
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
                                                          maxSliderPallet)
                                                    ],
                                                    textEditingController:
                                                        countPalletController,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                GestureDetector(
                                                  onTap: () => showTipPallet(
                                                    context,
                                                    getWidgetPosition(
                                                        countPalletKey),
                                                    (index) {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  child: Icon(
                                                    Icons.help_outline_outlined,
                                                    key: countPalletKey,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: minSliderPallet,
                                                    max: maxSliderPallet,
                                                    activeColor: Colors.red,
                                                    inactiveColor:
                                                        Colors.grey[300],
                                                    thumbColor: Colors.white,
                                                    value: snapshot.data!
                                                        .toDouble(),
                                                    onChangeEnd: (value) =>
                                                        calcOrder(
                                                            loadingAnimation:
                                                                false),
                                                    onChanged: (value) {
                                                      countPallet
                                                          .add(value.toInt());
                                                      countPalletController
                                                              .text =
                                                          value
                                                              .toInt()
                                                              .toString();
                                                      countPalletControllerMore
                                                          .text = '';
                                                      additionalPalletCount
                                                          .add(0);
                                                      setState(() {});
                                                      ;
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
                                              height = 385.h;
                                              if (additional1) height += 170.h;
                                              if (additional2) height += 280.h;
                                            } else {
                                              height = 0.h;
                                            }
                                            return additionalTab(height);
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
                                    } else if (time == null) {
                                      MessageDialogs().showAlert('Ошибка',
                                          'Укажите дату когда нужно забрать');
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

                                    suggestionStart = sug;

                                    errorAddress =
                                        suggestionStart!.houseNumber != null
                                            ? null
                                            : 'Укажите номер дома';
                                    fromController.text =
                                        suggestionStart!.point!.address!;

                                    setState(() {});

                                    calcOrder();
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
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      StreamBuilder<bool>(
                        stream: additional1Controller.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          additional1 = snapshot.data!;
                          return Column(
                            children: [
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
                                'Если вы не хотите пачкать руки и предпочитаете наблюдать за чужой работой - закажите эту услугу. Егорка заберет коробки с вашего склада и погрузит их в свой авто. Если нужно - погрузит на паллету и запаллетирует (выберите услугу ниже).',
                                style: CustomTextStyle.grey14w400,
                                textAlign: TextAlign.justify,
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                height: snapshot.data! ? 180.h : 0.h,
                                child: Stack(
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
                                                      onFieldSubmitted:
                                                          (value) =>
                                                              calcOrder(),
                                                      onChanged: (value) {
                                                        int? res =
                                                            int.tryParse(value);
                                                        if (res != null) {
                                                          bucketCountLess15kg
                                                              .add(res);
                                                        } else {
                                                          bucketCountLess15kg
                                                              .add(0);
                                                        }
                                                        setState(() {});
                                                      },
                                                      focusNode:
                                                          bucketFocusLess15kg,
                                                      height: 45.h,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w),
                                                      fillColor: Colors.white,
                                                      hintText: '0',
                                                      textInputType:
                                                          TextInputType.number,
                                                      formatters: [
                                                        CustomInputFormatterSlider((double
                                                                    .tryParse(
                                                                        countBucketController
                                                                            .text) ??
                                                                0) -
                                                            (double.tryParse(
                                                                    countPalletControllerMore15kg
                                                                        .text) ??
                                                                0))
                                                      ],
                                                      textEditingController:
                                                          countPalletControllerLess15kg,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Slider(
                                                      min: minSliderBucket,
                                                      max: (double.tryParse(
                                                                  countBucketController
                                                                      .text) ??
                                                              0) -
                                                          (double.tryParse(
                                                                  countPalletControllerMore15kg
                                                                      .text) ??
                                                              0),
                                                      activeColor: Colors.red,
                                                      inactiveColor:
                                                          Colors.grey[300],
                                                      thumbColor: Colors.white,
                                                      value: snapshot.data!
                                                          .toDouble(),
                                                      onChangeEnd: (value) {
                                                        setState(() {});
                                                        calcOrder(
                                                            loadingAnimation:
                                                                false);
                                                      },
                                                      onChanged: (value) {
                                                        bucketCountLess15kg
                                                            .add(value.toInt());
                                                        countPalletControllerLess15kg
                                                                .text =
                                                            value
                                                                .toInt()
                                                                .toString();
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
                                                      onFieldSubmitted:
                                                          (value) =>
                                                              calcOrder(),
                                                      onChanged: (value) {
                                                        int? res =
                                                            int.tryParse(value);
                                                        if (res != null) {
                                                          bucketCountMore15kg
                                                              .add(res);
                                                        } else {
                                                          bucketCountMore15kg
                                                              .add(0);
                                                        }
                                                        setState(() {});
                                                      },
                                                      focusNode:
                                                          bucketFocusMore15kg,
                                                      height: 45.h,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w),
                                                      fillColor: Colors.white,
                                                      hintText: '0',
                                                      textInputType:
                                                          TextInputType.number,
                                                      formatters: [
                                                        CustomInputFormatterSlider((double
                                                                    .tryParse(
                                                                        countBucketController
                                                                            .text) ??
                                                                0) -
                                                            (double.tryParse(
                                                                    countPalletControllerLess15kg
                                                                        .text) ??
                                                                0))
                                                      ],
                                                      textEditingController:
                                                          countPalletControllerMore15kg,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Slider(
                                                      min: minSliderBucket,
                                                      max: (double.tryParse(
                                                                  countBucketController
                                                                      .text) ??
                                                              0) -
                                                          (double.tryParse(
                                                                  countPalletControllerLess15kg
                                                                      .text) ??
                                                              0),
                                                      activeColor: Colors.red,
                                                      inactiveColor:
                                                          Colors.grey[300],
                                                      thumbColor: Colors.white,
                                                      value: snapshot.data!
                                                          .toDouble(),
                                                      onChangeEnd: (value) {
                                                        setState(() {});
                                                        calcOrder(
                                                            loadingAnimation:
                                                                false);
                                                      },
                                                      onChanged: (value) {
                                                        bucketCountMore15kg
                                                            .add(value.toInt());
                                                        countPalletControllerMore15kg
                                                                .text =
                                                            value
                                                                .toInt()
                                                                .toString();
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
                      SizedBox(height: 10.h),
                      StreamBuilder<bool>(
                        stream: additional2Controller.stream,
                        initialData: false,
                        builder: (context, snapshot) {
                          additional2 = snapshot.data!;
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
                                          additional2Controller
                                              .add(additional2);
                                          additionalController.add(additional);
                                        },
                                        icon: additional2
                                            ? const Icon(
                                                Icons.keyboard_arrow_up)
                                            : const Icon(
                                                Icons.keyboard_arrow_down),
                                        splashRadius: 15,
                                      )
                                    ],
                                  ),
                                  const Text(
                                    'Егорка приедет к вам с паллетой и стрейч-пленкой. Самостоятельно запаллетирует ваш груз и отправится доставлять ваш товар. Если груз отправляется с нашего склада, то кладовщики разместят ваши коробки на паллету и погрузят водителю в кузов.',
                                    style: CustomTextStyle.grey14w400,
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 5.w),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: snapshot.data! ? 92.h : 0.h,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.w),
                                        Row(
                                          children: const [
                                            Text('Количество паллет?')
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        StreamBuilder<int>(
                                          stream: additionalPalletCount.stream,
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
                                                        additionalPalletCount
                                                            .add(res);
                                                      } else {
                                                        additionalPalletCount
                                                            .add(0);
                                                      }
                                                      setState(() {});
                                                    },
                                                    focusNode:
                                                        palletFocusAdditional,
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
                                                        (double.tryParse(
                                                                countPalletController
                                                                    .text) ??
                                                            0),
                                                      ),
                                                    ],
                                                    textEditingController:
                                                        countPalletControllerMore,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: 0,
                                                    max: (double.tryParse(
                                                            countPalletController
                                                                .text) ??
                                                        0),
                                                    activeColor: Colors.red,
                                                    inactiveColor:
                                                        Colors.grey[300],
                                                    thumbColor: Colors.white,
                                                    value: snapshot.data!
                                                        .toDouble(),
                                                    onChangeEnd: (value) {
                                                      setState(() {});
                                                      calcOrder(
                                                          loadingAnimation:
                                                              false);
                                                    },
                                                    onChanged: (value) {
                                                      additionalPalletCount
                                                          .add(value.toInt());
                                                      countPalletControllerMore
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
  }

  void scrolling() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  void calcOrder({bool loadingAnimation = true}) {
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

    String group = '';
    switch (typeGroup) {
      case TypeGroup.fbo:
        group = 'Marketplace';
        break;
      case TypeGroup.fbs:
        group = 'FBS';
        break;
      case TypeGroup.mixfbs:
        group = 'MixFBS';
        break;
      default:
        group = 'Marketplace';
    }

    if (typeGroup != TypeGroup.mixfbs) {
      if (suggestionStart != null && suggestionEnd != null) {
        BlocProvider.of<MarketPlacePageBloc>(context).add(
          CalcOrderMarketplace(
            loadingAnimation,
            coast != null ? coast!.result!.id : null,
            suggestionStart,
            suggestionEnd,
            ancillaries,
            time,
            group,
            nameController.text,
            phoneController.text,
            cargos,
          ),
        );
      } else {
        coast = null;
      }
    } else {
      final marketplaces =
          BlocProvider.of<SearchAddressBloc>(context).marketPlaces;
      BlocProvider.of<MarketPlacePageBloc>(context).add(
        MixFbsCalcEvent(
          loadingAnimation,
          CoastMarketPlace(
            type: "Truck",
            group: 'MixFBS',
            locations: [
              Location(
                date: time != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(time!)
                    : null,
                contact: Contact(
                    name: nameController.text,
                    phoneMobile: phoneController.text),
                point: pointModel.Point(
                  id: 'EGORKA_SC',
                  code:
                      '${marketplaces?.result.points[1].latitude},${marketplaces?.result.points[1].longitude}',
                ),
              ),
              Location(
                contact: Contact(
                    name: nameController.text,
                    phoneMobile: phoneController.text),
                point: pointModel.Point(
                  id: 'Egorka_SBOR_FBS',
                  code:
                      '${marketplaces?.result.points[0].latitude},${marketplaces?.result.points[0].longitude}',
                ),
              )
            ],
            ancillaries: ancillaries,
            cargos: cargos,
          ),
        ),
      );
    }
  }

  void showMarketPlaces(MarketPlaces marketplaces) {
    showCupertinoModalPopup<String>(
      barrierColor: Colors.black.withOpacity(0.4),
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
                            Navigator.of(ctx).pop();
                            calcOrder();
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
                  SizedBox(
                    height: 200.h,
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[200],
                      onSelectedItemChanged: (value) {
                        toController.text =
                            marketplaces.result.points[value].name!.first.name!;
                        // points = marketplaces.result.points[value];

                        suggestionEnd = Suggestions(
                          iD: null,
                          name: formOrder!
                                  .result!.locations!.last.point?.address ??
                              '',
                          point: pointModel.Point(
                            latitude:
                                marketplaces.result.points[value].latitude,
                            longitude:
                                marketplaces.result.points[value].latitude,
                          ),
                        );
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
}
