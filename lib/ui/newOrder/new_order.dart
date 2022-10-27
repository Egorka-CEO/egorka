import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/receiver.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/model/sender.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum TypeAdd { sender, receiver }

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  static Sender sender = Sender(
    firstName: 'Олег',
    secondName: 'Бочко',
    phone: '+79223747362',
    address: 'г.Москва, ул.Кижеватова д.23',
  );

  static Receiver receiver = Receiver(
    firstName: 'Максим',
    secondName: 'Яковлев',
    phone: '+79111119393',
    address: 'г.Москва, ул.Солнечная д.6',
  );

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  List<RouteOrder> routeOrderSender = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  List<RouteOrder> routeOrderReceiver = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  PanelController panelController = PanelController();
  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Material(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
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
              BlocBuilder<NewOrderPageBloc, NewOrderState>(
                  buildWhen: (previous, current) {
                if (current is NewOrderCloseBtmSheet) {
                  btmSheet = false;
                } else if (current is NewOrderStatedOpenBtmSheet) {
                  btmSheet = true;
                } else if (current is NewOrderStateCloseBtmSheet) {
                  btmSheet = false;
                  if (typeAdd != null && typeAdd == TypeAdd.sender) {
                    routeOrderSender.add(RouteOrder(adress: current.value!));
                  } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {
                    routeOrderReceiver.add(RouteOrder(adress: current.value!));
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Отправитель',
                                      style: CustomTextStyle.black15w500,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: routeOrderSender.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/from.png',
                                                    height: 25,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Flexible(
                                                    child: Text(
                                                      routeOrderSender[index]
                                                          .adress,
                                                      style: CustomTextStyle
                                                          .black15w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_downward_rounded,
                                                    color: Colors.grey[400],
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Text(
                                                    'Указать детали',
                                                    style:
                                                        CustomTextStyle.red15,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text('Имя: ${sender.secondName}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Фамилия: ${sender.firstName}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Телефон: ${sender.phone}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Адрес: ${sender.address}',
                                  //         style: CustomTextStyle.grey14w400)
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      typeAdd = TypeAdd.sender;
                                      BlocProvider.of<NewOrderPageBloc>(context)
                                          .add(NewOrderOpenBtmSheet());
                                      panelController.animatePanelToPosition(1,
                                          curve: Curves.easeInOutQuint,
                                          duration:
                                              Duration(milliseconds: 1000));
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          'Добавить отправителя',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Получатель',
                                      style: CustomTextStyle.black15w500,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: routeOrderReceiver.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/to.png',
                                                    height: 25,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Text(
                                                    routeOrderReceiver[index]
                                                        .adress,
                                                    style: CustomTextStyle
                                                        .black15w500,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Icon(
                                                    index ==
                                                            routeOrderReceiver
                                                                    .length -
                                                                1
                                                        ? Icons.flag
                                                        : Icons
                                                            .arrow_downward_rounded,
                                                    color: Colors.grey[400],
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Text(
                                                    'Указать детали',
                                                    style:
                                                        CustomTextStyle.red15,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text('Имя: ${receiver.secondName}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Фамилия: ${receiver.firstName}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Телефон: ${receiver.phone}',
                                  //         style: CustomTextStyle.grey14w400),
                                  //     Text('Адрес: ${receiver.address}',
                                  //         style: CustomTextStyle.grey14w400)
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      typeAdd = TypeAdd.receiver;
                                      BlocProvider.of<NewOrderPageBloc>(context)
                                          .add(NewOrderOpenBtmSheet());
                                      panelController.close();
                                      panelController.open();
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Добавить получателя',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 10),
                                    child: Text(
                                      'Что везем?',
                                      style: CustomTextStyle.black15w500,
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText:
                                        'Документы / Цветы / Техника / Личная вещь',
                                    textEditingController:
                                        TextEditingController(),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 10),
                                    child: Text(
                                      'Ценность вашего груза?',
                                      style: CustomTextStyle.black15w500,
                                    ),
                                  ),
                                  CustomTextField(
                                    hintText: 'До 100000 ₽',
                                    textEditingController:
                                        TextEditingController(),
                                  ),
                                ],
                              ),
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
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 1,
                                color: Colors.black12,
                              ),
                            ],
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
                                            .copyWith(letterSpacing: 3),
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
                        panel: AddAdressBottomSheetDraggable(
                          typeAdd: typeAdd,
                        ),
                        onPanelClosed: () {
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
      ),
    );
  }
}
