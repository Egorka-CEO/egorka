import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Тарифы',
              style: CustomTextStyle.black15w500,
            ),
            foregroundColor: Colors.red,
            elevation: 0.5,
          ),
          body: const WebView(
            initialUrl: 'https://marketplace.egorka.delivery',
          ),
        ),
      ),
    );
  }
}
