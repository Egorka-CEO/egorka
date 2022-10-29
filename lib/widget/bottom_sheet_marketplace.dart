import 'dart:async';
import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MarketPlaceBottomSheetDraggable extends StatefulWidget {
  TextEditingController fromController;
  PanelController panelController;
  TypeAdd? typeAdd;
  MarketPlaceBottomSheetDraggable({
    Key? key,
    required this.typeAdd,
    required this.fromController,
    required this.panelController,
  });

  @override
  State<MarketPlaceBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState
    extends State<MarketPlaceBottomSheetDraggable> {
  FocusNode focusFrom = FocusNode();

  List<DeliveryChocie> listChoice = [
    DeliveryChocie(title: 'Байк', icon: 'assets/images/ic_bike.png'),
    DeliveryChocie(title: 'Легковая', icon: 'assets/images/ic_car.png'),
    DeliveryChocie(title: 'Грузовая', icon: 'assets/images/ic_track.png'),
    DeliveryChocie(title: 'Ножками ;)', icon: 'assets/images/ic_leg.png'),
  ];

  Address? address;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
        builder: (context, snapshot) {
      return _floatingPanel(context);
    });
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<MarketPlacePageBloc>(context);
    return Container(
      margin:
          MediaQuery.of(context).viewInsets + const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black12,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: (MediaQuery.of(context).size.width * 45) / 100,
                right: (MediaQuery.of(context).size.width * 45) / 100,
                bottom: 10),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey,
              ),
            ),
          ),
          if (widget.typeAdd != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
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
                            fillColor: MaterialStateProperty.all(
                                widget.typeAdd == TypeAdd.sender
                                    ? Colors.red
                                    : Colors.blue),
                            shape: const CircleBorder(),
                            onChanged: ((value) {}),
                          ),
                          Expanded(
                            child: CustomTextField(
                              onTap: () {
                                // panelController.open();
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  focusFrom.requestFocus();
                                });
                              },
                              focusNode: focusFrom,
                              fillColor: Colors.grey[200],
                              hintText: 'Откуда забрать?',
                              onFieldSubmitted: (text) {
                                // panelController.close();
                                focusFrom.unfocus();
                              },
                              textEditingController: widget.fromController,
                              onChanged: (value) {
                                bloc.add(MarketPlace(value));
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _searchList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 215,
          child: BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
            buildWhen: (previous, current) {
              if (current is MarketPlaceSuccess) {
                address = current.address;
              }
              return true;
            },
            builder: ((context, state) {
              if (state is MarketPlaceStated) {
                return const SizedBox();
              } else if (state is MarketPlaceLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              } else if (state is MarketPlaceSuccess) {
                return address != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: state.address!.result.suggestions!.length,
                          itemBuilder: (context, index) {
                            return _pointCard(state, index, context);
                          },
                        ),
                      )
                    : Container();
              } else {
                return const Text('');
              }
            }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Container _pointCard(
      MarketPlaceSuccess state, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      height: 50,
      child: InkWell(
        onTap: () {
          widget.fromController.text =
              state.address!.result.suggestions![index].name;
          BlocProvider.of<MarketPlacePageBloc>(context).add(
              MarketPlaceStatedCloseBtmSheet(
                  state.address!.result.suggestions![index].name));

          focusFrom.unfocus();
          widget.panelController.close();
        },
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidget.iconGPSSmall(
                        color: widget.typeAdd == TypeAdd.sender
                            ? Colors.red
                            : Colors.blue))),
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
