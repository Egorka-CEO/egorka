import 'dart:async';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSheetDraggable extends StatefulWidget {
  const BottomSheetDraggable({Key? key});

  @override
  State<BottomSheetDraggable> createState() => _BottomSheetDraggableState();
}

class _BottomSheetDraggableState extends State<BottomSheetDraggable> {
  final TextEditingController fromController = TextEditingController();

  final TextEditingController toController = TextEditingController();

  FocusNode focusFrom = FocusNode();

  FocusNode focusTo = FocusNode();

  PanelController panelController = PanelController();

  final stream = StreamController();

  bool _visible = false;

  List<DeliveryChocie> listChoice = [
    DeliveryChocie(title: 'Байк', icon: 'assets/images/ic_bike.png'),
    DeliveryChocie(title: 'Легковая', icon: 'assets/images/ic_car.png'),
    DeliveryChocie(title: 'Грузовая', icon: 'assets/images/ic_track.png'),
    DeliveryChocie(title: 'Ножками ;)', icon: 'assets/images/ic_leg.png'),
  ];

  // final _sheetController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAddressBloc, SearchAddressState>(
        builder: (context, snapshot) {
      var bloc = BlocProvider.of<SearchAddressBloc>(context);
      return SlidingUpPanel(
        controller: panelController,
        renderPanelSheet: false,
        panel: _floatingPanel(context),
        onPanelClosed: () {
          focusFrom.unfocus();
          focusTo.unfocus();
          _visible = false;
        },
        onPanelOpened: () {
          _visible = true;
          if (!focusFrom.hasFocus && !focusTo.hasFocus) {
            panelController.close();
          }
        },
        onPanelSlide: (size) {
          if (size.toStringAsFixed(1) == (0.5).toString()) {
            focusFrom.unfocus();
            focusTo.unfocus();
          }
        },
        maxHeight: 735,
        minHeight: bloc.isPolilyne ? 415 : 215,
        defaultPanelState: PanelState.CLOSED,
      );
    });
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<SearchAddressBloc>(context);
    return Container(
      margin:
          MediaQuery.of(context).viewInsets + const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black12,
          ),
        ],
        color: Colors.white.withOpacity(0.9),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: (MediaQuery.of(context).size.width * 45) / 100,
                right: (MediaQuery.of(context).size.width * 45) / 100),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder<dynamic>(
              stream: stream.stream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: false,
                              fillColor: MaterialStateProperty.all(Colors.red),
                              shape: const CircleBorder(),
                              onChanged: ((value) {}),
                            ),
                            Expanded(
                              child: CustomTextField(
                                onTap: () {
                                  panelController.open();
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    focusFrom.requestFocus();
                                  });
                                  bloc.add(SearchAddressClear());
                                },
                                focusNode: focusFrom,
                                fillColor: Colors.grey[200],
                                hintText: 'Откуда забрать?',
                                enabled: !bloc.isPolilyne,
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusFrom.unfocus();
                                },
                                textEditingController: fromController,
                                onChanged: (value) {
                                  bloc.add(SearchAddress(value));
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                focusFrom.unfocus();
                                focusTo.unfocus();
                                panelController.close();
                                bloc.add(SearchMeEvent());
                              },
                              child: const Icon(
                                Icons.gps_fixed,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[200]),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: false,
                              fillColor: MaterialStateProperty.all(Colors.blue),
                              shape: const CircleBorder(),
                              onChanged: ((value) {}),
                            ),
                            Expanded(
                              child: CustomTextField(
                                onTap: () {
                                  panelController.open();
                                  bloc.add(SearchAddressClear());
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    focusTo.requestFocus();
                                  });
                                },
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusTo.unfocus();
                                },
                                enabled: !bloc.isPolilyne,
                                focusNode: focusTo,
                                fillColor: Colors.grey[200],
                                hintText: 'Куда отвезти?',
                                textEditingController: toController,
                                onChanged: (value) {
                                  stream.add('event');
                                  bloc.add(SearchAddress(value));
                                },
                              ),
                            ),
                            toController.text.isEmpty
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      bloc.add(DeletePolilyneEvent());
                                      toController.text = '';
                                      stream.add('event');
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    _searchList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _searchList() {
    return SizedBox(
      height: 212,
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
        buildWhen: (previous, current) {
          if (current is ChangeAddressSuccess) {
            if (fromController.text != current.geoData!.address) {
              fromController.text = current.geoData!.address;
            }
          }
          return true;
        },
        builder: ((context, state) {
          var bloc = BlocProvider.of<SearchAddressBloc>(context);
          if (state is SearchAddressStated) {
            return const SizedBox();
          } else if (state is SearchAddressLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            );
          } else if (state is SearchAddressSuccess) {
            return _visible
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.address!.result.suggestions!.length,
                    itemBuilder: (context, index) {
                      return _pointCard(state, index, context);
                    },
                  )
                : Container();
          } else if (bloc.isPolilyne) {
            return ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: listChoice.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/newOrder'),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(listChoice[index].title),
                      leading: Image.asset(listChoice[index].icon, height: 50),
                    ),
                  );
                }));
          } else {
            return const Text('');
          }
        }),
      ),
    );
  }

  Container _pointCard(
      SearchAddressSuccess state, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      height: 50,
      child: InkWell(
        onTap: () {
          if (focusFrom.hasFocus) {
            fromController.text =
                state.address!.result.suggestions![index].name;
          } else if (focusTo.hasFocus) {
            toController.text = state.address!.result.suggestions![index].name;
          }

          if (toController.text.isNotEmpty && toController.text.isNotEmpty) {
            BlocProvider.of<SearchAddressBloc>(context)
                .add(SearchAddressPolilyne(toController.text));
          } else {
            BlocProvider.of<SearchAddressBloc>(context).add(
              JumpToPointEvent(
                state.address!.result.suggestions![index].point!,
              ),
            );
          }

          focusFrom.unfocus();
          focusTo.unfocus();
          panelController.close();
        },
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidget.iconGPSSmall())),
            const SizedBox(width: 15),
            Expanded(
              flex: 10,
              child: Text(
                state.address!.result.suggestions![index].name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
