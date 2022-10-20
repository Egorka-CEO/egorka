import 'dart:async';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSheetDraggable extends StatefulWidget {
  BottomSheetDraggable({Key? key});

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

  final _sheetController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      renderPanelSheet: false,
      panel: _floatingPanel(context),
      onPanelClosed: () {
        focusFrom.unfocus();
        focusTo.unfocus();
        _visible = false;
        print('closed');
      },
      onPanelOpened: () {
        print('opened');
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
        print(size.toStringAsFixed(2));
      },
      maxHeight: 720,
      minHeight: 200,
      defaultPanelState: PanelState.CLOSED,
    );
  }

  Widget _floatingPanel(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 10,
        //     color: Colors.black26,
        //   ),
        // ],
        color: Colors.grey[200],
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
                        color: Colors.grey[300],
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
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    focusFrom.requestFocus();
                                  });
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(SearchAddressClear());
                                },
                                focusNode: focusFrom,
                                fillColor: Colors.grey[300],
                                hintText: 'Откуда забрать?',
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusFrom.unfocus();
                                },
                                textEditingController: fromController,
                                onChanged: (value) {
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(SearchAddress(value));
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                focusFrom.unfocus();
                                focusTo.unfocus();
                                panelController.close();
                                BlocProvider.of<SearchAddressBloc>(context)
                                    .add(SearchMeEvent());
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
                          color: Colors.grey[300]),
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
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(SearchAddressClear());
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    focusTo.requestFocus();
                                  });
                                },
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusTo.unfocus();
                                },
                                focusNode: focusTo,
                                fillColor: Colors.grey[300],
                                hintText: 'Куда отвезти?',
                                textEditingController: toController,
                                onChanged: (value) {
                                  stream.add('event');
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(SearchAddress(value));
                                },
                              ),
                            ),
                            toController.text.isEmpty
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
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

  Container _searchList() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 10),
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
          if (state is SearchAddressStated) {
            return const SizedBox();
          } else if (state is SearchAddressLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
              ],
            );
          } else if (state is SearchAddressSuccess) {
            return _visible
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.address!.result.suggestions!.length,
                    // physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _pointCard(state, index, context);
                    },
                  )
                : Container();
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

          focusFrom.unfocus();
          focusTo.unfocus();
          panelController.close();
          BlocProvider.of<SearchAddressBloc>(context).add(
            JumpToPointEvent(
              state.address!.result.suggestions![index].point!,
            ),
          );
          // BlocProvider.of<SearchAddressBloc>(
          //         context)
          //     .add(SearchAddressClear());
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
