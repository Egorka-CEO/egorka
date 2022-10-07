import 'package:flutter/material.dart';

class BottomSheetDraggable extends StatelessWidget {
  const BottomSheetDraggable({Key? key}) : super(key: key);

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
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            decoration:
                                InputDecoration.collapsed(hintText: 'Откуда?'),
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
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            decoration: InputDecoration.collapsed(
                              hintText: 'Куда?',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
