import 'dart:async';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetDraggable extends StatelessWidget {
  BottomSheetDraggable({Key? key});

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  FocusNode focusFrom = FocusNode();
  FocusNode focusTo = FocusNode();

  final stream = StreamController();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.25,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.grey[200],
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              controller: scrollController,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                    fillColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: const CircleBorder(),
                                    onChanged: ((value) {}),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      onTap: () {
                                        BlocProvider.of<SearchAddressBloc>(
                                                context)
                                            .add(SearchAddressClear());
                                      },
                                      focusNode: focusFrom,
                                      fillColor: Colors.grey[300],
                                      hintText: 'Откуда забрать?',
                                      textEditingController: fromController,
                                      onChanged: (value) {
                                        BlocProvider.of<SearchAddressBloc>(
                                                context)
                                            .add(SearchAddress(value));
                                      },
                                    ),
                                  ),
                                  const Icon(
                                    Icons.gps_fixed,
                                    color: Colors.red,
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
                                    fillColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    shape: const CircleBorder(),
                                    onChanged: ((value) {}),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      onTap: () {
                                        BlocProvider.of<SearchAddressBloc>(
                                                context)
                                            .add(SearchAddressClear());
                                      },
                                      focusNode: focusTo,
                                      fillColor: Colors.grey[300],
                                      hintText: 'Куда отвезти?',
                                      textEditingController: toController,
                                      onChanged: (value) {
                                        stream.add('event');
                                        BlocProvider.of<SearchAddressBloc>(
                                                context)
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: BlocBuilder<SearchAddressBloc,
                                SearchAddressState>(
                              builder: ((context, state) {
                                if (state is SearchAddressStated) {
                                  return const SizedBox();
                                } else if (state is SearchAddressLoading) {
                                  return const CircularProgressIndicator();
                                } else if (state is SearchAddressSuccess) {
                                  // if() {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  // }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state
                                        .address!.result.suggestions!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (focusFrom.hasFocus) {
                                              fromController.text = state
                                                  .address!
                                                  .result
                                                  .suggestions![index]
                                                  .name;
                                            } else if (focusTo.hasFocus) {
                                              toController.text = state
                                                  .address!
                                                  .result
                                                  .suggestions![index]
                                                  .name;
                                            }

                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            BlocProvider.of<SearchAddressBloc>(
                                                    context)
                                                .add(SearchAddressClear());
                                          },
                                          child: Text(state.address!.result
                                              .suggestions![index].name),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Text('Ничего не найдено');
                                }
                              }),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
