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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: const [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Откуда',
                          border: OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Куда',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ],
                  ),
                )
              ]
            )
          );
        },
      )
    );
  }
}
