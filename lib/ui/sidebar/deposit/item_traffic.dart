import 'package:egorka/model/traffic_deposit.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemTraffic extends StatelessWidget {
  final depositTraffic = [
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text('Дата с...'),
              ),
              CustomTextField(
                hintText: 'ДД.ММ.ГГГГ',
                textEditingController: TextEditingController(),
                textInputType: TextInputType.number,
                width: 120,
                fillColor: Colors.white,
                height: 50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text('Дата по...'),
              ),
              CustomTextField(
                hintText: 'ДД.ММ.ГГГГ',
                textEditingController: TextEditingController(),
                textInputType: TextInputType.number,
                width: 120,
                fillColor: Colors.white,
                height: 50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: depositTraffic.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 50,
                  color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Expanded(child: Text('№')),
                      Expanded(
                        child: Text(
                          'Создано',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Оплачено',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Комментарий',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Сумма',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Статус',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                );
              }
              return Container(
                height: 50,
                color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      '${depositTraffic[index - 1].number}',
                      style: const TextStyle(color: Colors.red),
                    )),
                    Expanded(
                        child: Text(DateFormat.yMd('ru')
                            .format(depositTraffic[index - 1].dateCreation),
                          textAlign: TextAlign.center,)),
                    Expanded(
                        child: Text(DateFormat.yMd('ru')
                            .format(depositTraffic[index - 1].datePayment),
                          textAlign: TextAlign.center,)),
                    Expanded(
                        child: Text(depositTraffic[index - 1].comment,
                          textAlign: TextAlign.center,)),
                    Expanded(
                        child:
                            Text('${depositTraffic[index - 1].rubles} руб.',
                          textAlign: TextAlign.center,)),
                    Expanded(
                        child: Text(
                      depositTraffic[index - 1].status,
                      style: const TextStyle(color: Colors.orange),
                          textAlign: TextAlign.center,
                    )),
                    const SizedBox(width: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
