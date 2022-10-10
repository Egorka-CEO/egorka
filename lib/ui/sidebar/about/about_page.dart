import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        const Align(
                          child: Text('О приложении',
                              style: CustomTextStyle.black15w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            SvgPicture.asset(
              'assets/icons/logo_egorka.svg',
              height: 60,
            ),
            const SizedBox(height: 20),
            const Text('Version 0.1', style: CustomTextStyle.black15w500),
            const Spacer(flex: 20),
            const Text('Команда разработки',
                style: CustomTextStyle.black15w500),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/ic_broseph.png',
              height: 20,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
