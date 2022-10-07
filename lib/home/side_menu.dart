import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final TextStyle style = const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  final TextStyle style1 = const TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.black);

  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Eg', style: style1),
                    TextSpan(text:'o', style: style1.copyWith(color: Colors.red)),
                    TextSpan(text: 'rka', style: style1),
                  ]
                )
              ),
              const Divider(height: 30),
              Text('Текущий заказ', style: style),
              const Divider(height: 30),
              Text('Маркетплейсы', style: style),
              const Divider(height: 30),
              Text('О приложении', style: style)
            ],
          ),
        ),
      ),
    );
  }
}
