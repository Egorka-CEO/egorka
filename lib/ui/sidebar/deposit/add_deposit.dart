import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/deposit_history.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddDeposit extends StatelessWidget {
  final depositHistory = [
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 8, 12),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 8, 17),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 8, 20),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 8, 21),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 8, 01),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 8, 05),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 9, 10),
      rubles: '1111',
    ),
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 9, 14),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 9, 15),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 9, 18),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 9, 25),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 9, 28),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 9, 29),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 10, 01),
      rubles: '1111',
    ),
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 10, 04),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 10, 05),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 10, 07),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 10, 09),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 10, 10),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 10, 11),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 10, 11),
      rubles: '1111',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Пополнение депозита',
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Укажите сумму пополнения:',
              style: CustomTextStyle.black15w500,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CustomTextField(
                  hintText: '15 000',
                  textEditingController: TextEditingController(),
                  textInputType: TextInputType.number,
                  width: 150,
                  fillColor: Colors.white,
                  height: 50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                ),
                const SizedBox(width: 15),
                const Text('руб'),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        'ПОПОЛНИТЬ',
                        style: CustomTextStyle.white15w600.copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Ранее выставленные счета',
              style: CustomTextStyle.black15w700.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: depositHistory.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 50,
                      color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                      child: Row(
                        children: const [
                          SizedBox(width: 10),
                          Expanded(flex: 2, child: Text('№')),
                          SizedBox(width: 10),
                          Expanded(flex: 4, child: Text('Дата выставления')),
                          Expanded(flex: 3, child: Text('Сумма')),
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
                            flex: 2,
                            child: Text('${depositHistory[index - 1].number}')),
                        Expanded(
                            flex: 4,
                            child: Text(DateFormat.yMMMMd('ru')
                                .format(depositHistory[index - 1].date))),
                        Expanded(
                            flex: 3,
                            child:
                                Text('${depositHistory[index - 1].rubles} руб.')),
                        const SizedBox(width: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
