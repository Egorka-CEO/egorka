import 'dart:async';
import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/bottom_sheet_marketplace.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool btmSheet = false;

  TypeAdd? typeAdd;

  List<RouteOrder> routeOrderSender = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  List<RouteOrder> routeOrderReceiver = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  TextEditingController controller = TextEditingController();

  TextEditingController fromController = TextEditingController();

  TextEditingController toController = TextEditingController();

  PanelController panelController = PanelController();

  final bucketController = StreamController<int>();
  final palletController = StreamController<int>();

  @override
  void dispose() {
    bucketController.close();
    palletController.close();
    super.dispose();
  }

  void _findMe() async {
    if (await Location().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
          language: 'RU',
          googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");
      fromController.text = data.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarketPlacePageBloc>(
          create: (context) => MarketPlacePageBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        BlocProvider.of<MarketPlacePageBloc>(context).add(GetMarketPlaces());
        return Material(
          color: Colors.grey[200],
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.5),
              leading: const SizedBox(),
              flexibleSpace: Column(
                children: [
                  const Spacer(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text('Отмена',
                                      style: CustomTextStyle.red15),
                                ),
                                const Align(
                                  child: Text(
                                    'Оформление заказа',
                                    style: CustomTextStyle.black15w500,
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
            body: Column(
              children: [
                BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
                    buildWhen: (previous, current) {
                  if (current is MarketPlaceCloseBtmSheet) {
                    btmSheet = false;
                  } else if (current is MarketPlaceStatedOpenBtmSheet) {
                    btmSheet = true;
                  } else if (current is MarketPlaceStateCloseBtmSheet) {
                    btmSheet = false;
                    if (typeAdd != null && typeAdd == TypeAdd.sender) {
                      print('object TypeAdd.sender');

                      fromController.text = controller.text;
                      routeOrderSender.add(RouteOrder(adress: current.value!));
                    } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {
                      routeOrderReceiver
                          .add(RouteOrder(adress: current.value!));
                      print('object TypeAdd.receiver');

                      toController.text = controller.text;
                    }
                  }

                  return true;
                }, builder: (context, snapshot) {
                  return Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15),
                                const Text(
                                  'Доставка до маркетплейса',
                                  style: CustomTextStyle.black15w700,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Как это работает?',
                                  style: CustomTextStyle.red15,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: const [
                                    Text(
                                      'Откуда забрать?',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                            onChanged: ((value) {}),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.text = '';
                                                typeAdd = TypeAdd.sender;
                                                BlocProvider.of<
                                                            MarketPlacePageBloc>(
                                                        context)
                                                    .add(
                                                        MarketPlaceOpenBtmSheet());
                                                panelController
                                                    .animatePanelToPosition(
                                                  1,
                                                  curve: Curves.easeInOutQuint,
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                );
                                              },
                                              child: CustomTextField(
                                                height: 50,
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                fillColor: Colors.white,
                                                enabled: false,
                                                hintText: '',
                                                textEditingController:
                                                    fromController,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              _findMe();
                                            },
                                            child: const Icon(
                                              Icons.gps_fixed,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      'Не обязательно к заполнению',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        height: 50,
                                        fillColor: Colors.white,
                                        hintText: 'Подъезд',
                                        textInputType: TextInputType.number,
                                        textEditingController:
                                            TextEditingController(),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: CustomTextField(
                                        height: 50,
                                        fillColor: Colors.white,
                                        hintText: 'Этаж',
                                        textInputType: TextInputType.number,
                                        textEditingController:
                                            TextEditingController(),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: CustomTextField(
                                        height: 50,
                                        fillColor: Colors.white,
                                        hintText: 'Офис/кв.',
                                        textInputType: TextInputType.number,
                                        textEditingController:
                                            TextEditingController(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text('Куда отвезти?',
                                        style: CustomTextStyle.grey15bold),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: false,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue),
                                            shape: const CircleBorder(),
                                            onChanged: ((value) {}),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                final marketplaces = BlocProvider
                                                        .of<MarketPlacePageBloc>(
                                                            context)
                                                    .marketPlaces;
                                                if (marketplaces != null) {
                                                  showCupertinoModalPopup<
                                                      String>(
                                                    barrierColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 200,
                                                        child: CupertinoPicker(
                                                          backgroundColor:
                                                              Colors.grey[200],
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            toController.text =
                                                                marketplaces
                                                                    .result
                                                                    .points[
                                                                        value]
                                                                    .name[0]
                                                                    .name;
                                                          },
                                                          itemExtent: 32.0,
                                                          children: marketplaces
                                                              .result.points
                                                              .map((e) => Text(e
                                                                  .name[0]
                                                                  .name))
                                                              .toList(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: CustomTextField(
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                height: 50,
                                                fillColor: Colors.white,
                                                enabled: false,
                                                hintText: '',
                                                textEditingController:
                                                    toController,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              final marketplaces = BlocProvider
                                                      .of<MarketPlacePageBloc>(
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
                                                  final points =
                                                      result as Points;
                                                  toController.text = points.name[0].name;
                                                }
                                              }
                                            },
                                            child: const Icon(
                                              Icons.map_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      'Когда забрать?',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          height: 50,
                                          fillColor: Colors.white,
                                          hintText: '',
                                          textEditingController:
                                              TextEditingController(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.help_outline_outlined,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        'Оформить доставку до Маркетплейса на завтра можно строго до 15:00.',
                                        style: CustomTextStyle.grey15,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      'Ваши контакты',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        height: 50,
                                        fillColor: Colors.white,
                                        hintText: 'Имя',
                                        textEditingController:
                                            TextEditingController(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        height: 50,
                                        fillColor: Colors.white,
                                        hintText: '+7 (999) 888-77-66',
                                        textInputType: TextInputType.number,
                                        textEditingController:
                                            TextEditingController(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      'Кол-во коробок?',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                StreamBuilder<int>(
                                    stream: bucketController.stream,
                                    initialData: 32,
                                    builder: (context, snapshot) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              height: 50,
                                              fillColor: Colors.white,
                                              hintText: '0',
                                              textInputType:
                                                  TextInputType.number,
                                              textEditingController:
                                                  TextEditingController(
                                                      text: snapshot.data!
                                                          .toString()),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.help_outline_outlined,
                                            color: Colors.red,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Slider(
                                              min: 1,
                                              max: 50,
                                              thumbColor: Colors.red,
                                              value: snapshot.data!.toDouble(),
                                              onChanged: (value) {
                                                bucketController
                                                    .add(value.toInt());
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Text(
                                      'Кол-во паллет?',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                StreamBuilder<int>(
                                    stream: palletController.stream,
                                    initialData: 16,
                                    builder: (context, snapshot) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              height: 50,
                                              fillColor: Colors.white,
                                              hintText: '0',
                                              textInputType:
                                                  TextInputType.number,
                                              textEditingController:
                                                  TextEditingController(
                                                      text: snapshot.data!
                                                          .toString()),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.help_outline_outlined,
                                            color: Colors.red,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Slider(
                                              min: 1,
                                              max: 50,
                                              thumbColor: Colors.red,
                                              value: snapshot.data!.toDouble(),
                                              onChanged: (value) {
                                                palletController
                                                    .add(value.toInt());
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                const SizedBox(height: 210)
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.only(bottom: 40),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_leg.png',
                                        color: Colors.red,
                                        height: 90,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Пеший',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            '1900 ₽',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        '}',
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('400 ₽ доставка'),
                                          Text('0 ₽ доп. услуги'),
                                          Text('11 ₽ сбор-плат. сист.'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Text(
                                          'ОПЛАТИТЬ ЗАКАЗ',
                                          style: CustomTextStyle.white15w600
                                              .copyWith(letterSpacing: 1),
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
                          panel: MarketPlaceBottomSheetDraggable(
                            typeAdd: typeAdd,
                            fromController: controller,
                            panelController: panelController,
                          ),
                          onPanelClosed: () {
                            // if (typeAdd == TypeAdd.sender) {
                            //   fromController.text = controller.text;
                            // } else if (typeAdd == TypeAdd.receiver) {
                            //   toController.text = controller.text;
                            // }
                            // controller.text = '';
                            // focusFrom.unfocus();
                            // focusTo.unfocus();
                            // _visible = false;
                          },
                          onPanelOpened: () {
                            // _visible = true;
                            // if (!focusFrom.hasFocus && !focusTo.hasFocus) {
                            //   panelController.close();
                            // }
                          },
                          onPanelSlide: (size) {
                            // if (size.toStringAsFixed(1) == (0.5).toString()) {
                            //   focusFrom.unfocus();
                            //   focusTo.unfocus();
                            // }
                          },
                          maxHeight: 700,
                          minHeight: 0,
                          defaultPanelState: PanelState.CLOSED,
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }
}
