import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/receiver.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/model/sender.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailsPage extends StatefulWidget {
  int index;
  TypeAdd typeAdd;

  DetailsPage({
    super.key,
    required this.index,
    required this.typeAdd,
  });

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
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<RouteOrder> routeOrderSender = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  List<RouteOrder> routeOrderReceiver = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  TextEditingController controller = TextEditingController();

  PanelController panelController = PanelController();

  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  Widget build(BuildContext context) {
    print('object ${widget.index} ${widget.typeAdd}');
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Material(
        color: Colors.white,
        child: Scaffold(
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
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_ios,
                                      size: 25,
                                      color: Colors.red,
                                    ),
                                    Text('Назад',
                                        style: CustomTextStyle.red15
                                            .copyWith(fontSize: 17)),
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
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
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: widget.typeAdd == TypeAdd.sender ? Colors.red : Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                      Text(widget.typeAdd == TypeAdd.sender ?
                        'А${widget.index}' : 'Б${widget.index}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(widget.typeAdd == TypeAdd.sender?
                          'Откуда забрать?' : 'Куда отвезти?',
                          style: CustomTextStyle.grey15bold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              // Checkbox(
                              //   value: false,
                              //   fillColor:
                              //       MaterialStateProperty.all(Colors.red),
                              //   shape: const CircleBorder(),
                              //   onChanged: ((value) {}),
                              // ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.text = '';
                                    typeAdd = TypeAdd.sender;
                                    // BlocProvider.of<NewOrderPageBloc>(
                                    //               context)
                                    //           .add(NewOrderOpenBtmSheet());
                                    // BlocProvider.of<MarketPlacePageBloc>(
                                    //         context)
                                    //     .add(MarketPlaceOpenBtmSheet());
                                    setState(() {
                                      
                                    });
                                    panelController.animatePanelToPosition(
                                      1,
                                      curve: Curves.easeInOutQuint,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                    );
                                  },
                                  child: CustomTextField(
                                    height: 50,
                                    contentPadding: const EdgeInsets.all(0),
                                    fillColor: Colors.white,
                                    enabled: false,
                                    hintText: '',
                                    textEditingController: controller,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Text(
                          'Не обязательно к заполнению',
                          style: CustomTextStyle.grey15bold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            height: 50,
                            fillColor: Colors.white,
                            hintText: 'Подъезд',
                            textInputType: TextInputType.number,
                            textEditingController: TextEditingController(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomTextField(
                            height: 50,
                            fillColor: Colors.white,
                            hintText: 'Этаж',
                            textInputType: TextInputType.number,
                            textEditingController: TextEditingController(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomTextField(
                            height: 50,
                            fillColor: Colors.white,
                            hintText: 'Офис/кв.',
                            textInputType: TextInputType.number,
                            textEditingController: TextEditingController(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Text('Контакты получателя',
                            style: CustomTextStyle.grey15bold),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // controller.text = '';
                        // typeAdd = TypeAdd.sender;
                        // BlocProvider.of<MarketPlacePageBloc>(context)
                        //     .add(MarketPlaceOpenBtmSheet());
                        // panelController.animatePanelToPosition(
                        //   1,
                        //   curve: Curves.easeInOutQuint,
                        //   duration: const Duration(milliseconds: 1000),
                        // );
                      },
                      child: CustomTextField(
                        height: 50,
                        // contentPadding: const EdgeInsets.all(0),
                        fillColor: Colors.white,
                        hintText: 'Имя',
                        textEditingController: TextEditingController(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        // controller.text = '';
                        // typeAdd = TypeAdd.sender;
                        // BlocProvider.of<MarketPlacePageBloc>(context)
                        //     .add(MarketPlaceOpenBtmSheet());
                        // panelController.animatePanelToPosition(
                        //   1,
                        //   curve: Curves.easeInOutQuint,
                        //   duration: const Duration(milliseconds: 1000),
                        // );
                      },
                      child: CustomTextField(
                        height: 50,
                        // contentPadding: const EdgeInsets.all(0),
                        fillColor: Colors.white,
                        // enabled: false,
                        hintText: '+7 (___) ___-__-__',
                        textEditingController: TextEditingController(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Text(
                          'Поручения для Егорки',
                          style: CustomTextStyle.grey15bold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              height: 300,
                              width: 100,
                              fillColor: Colors.white,
                              hintText: '',
                              maxLines: 10,
                              textEditingController: TextEditingController(),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                    routeOrderSender.add(RouteOrder(adress: current.value!));
                  } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {
                    routeOrderReceiver.add(RouteOrder(adress: current.value!));
                  }
                }

                return true;
              }, builder: (context, snapshot) {
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
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
