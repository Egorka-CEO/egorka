import 'dart:async';
import 'package:flutter/material.dart';

class BottomSheetDraggable extends StatelessWidget {
  BottomSheetDraggable({Key? key});

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final stream = StreamController();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: 0.25,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              controller: scrollController,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: StreamBuilder<dynamic>(
                    stream: stream.stream,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: fromController,
                                      onChanged: (value) => stream.add('event'),
                                      decoration: const InputDecoration(
                                        fillColor: Colors.red,
                                        hintText: 'Откуда забрать?',
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.gps_fixed,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: toController,
                                      onChanged: (value) {
                                        stream.add('event');
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Куда отвезти?',
                                      ),
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
                                        )
                                ],
                              ),
                            ),
                          )
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
