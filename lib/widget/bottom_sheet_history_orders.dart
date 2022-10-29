import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/history.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HistoryOrdersBottomSheetDraggable extends StatefulWidget {
  PanelController panelController;
  HistoryOrdersBottomSheetDraggable({
    Key? key,
    required this.panelController,
  });

  @override
  State<HistoryOrdersBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState
    extends State<HistoryOrdersBottomSheetDraggable> {
  List<HistoryModel> listHistory = [
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибиревоsssss sssssss sssss ssss sssssss ssssss',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '11.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: false,
    ),
    HistoryModel(
      date: '10.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '9.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '9.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: false,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: true,
    ),
    HistoryModel(
      date: '12.10.2021',
      adress: 'Метро Бибирево',
      title: 'Байк',
      icon: 'assets/images/ic_bike.png',
      status: false,
    ),
  ];

  Address? address;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _floatingPanel(context),
    );
  }

  Widget _floatingPanel(BuildContext context) {
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
        color: Colors.grey[200],
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
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: _searchList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: listHistory.length,
        itemBuilder: (context, index) {
          return _pointCard(listHistory[index], index, context);
        },
      ),
    );
  }

  Container _pointCard(HistoryModel state, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 15),
      child: InkWell(
        onTap: () {
          widget.panelController.close();
          Navigator.of(context).pushNamed(AppRoute.historyOrder);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.date,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.grey[400],
                height: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Поездка днём, в 16:16',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          state.status
                              ? Text(
                                  state.adress,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text(
                                  'Отменено',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      )),
                  // const SizedBox(width: 15),
                  // Spacer(),
                  Expanded(
                    flex: 2,
                    child: Image.asset(state.icon),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
