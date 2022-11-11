import 'dart:async';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/ui/sidebar/deposit/item_traffic.dart';
import 'package:flutter/material.dart';

class TrafficDeposit extends StatefulWidget {
  @override
  State<TrafficDeposit> createState() => _TrafficDepositState();
}

class _TrafficDepositState extends State<TrafficDeposit> {
  @override
  void dispose() {
    tabBarController.close();
    super.dispose();
  }

  final tabBarController = StreamController<int>();

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Движение по депозиту',
          style: CustomTextStyle.black15w500,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: tabBarController.stream,
            initialData: 0,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            tabBarController.add(0);
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: snapshot.data! == 0 ? Colors.red : null,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Все счета',
                                style: snapshot.data! == 0
                                    ? CustomTextStyle.white15w600
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            tabBarController.add(1);
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: snapshot.data! == 1 ? Colors.red : null,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Пополнения',
                                style: snapshot.data! == 1
                                    ? CustomTextStyle.white15w600
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            tabBarController.add(2);
                            pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: snapshot.data! == 2 ? Colors.red : null,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Списания',
                                style: snapshot.data! == 2
                                    ? CustomTextStyle.white15w600
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: SizedBox(
                height: 400,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    ItemTraffic(),
                    ItemTraffic(),
                    ItemTraffic(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
