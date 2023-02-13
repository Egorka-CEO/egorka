import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  String url;
  int id;
  int pin;

  PaymentWebView(this.url, this.id, this.pin);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController? _controller;

  @override
  void dispose() {
    super.dispose();
    _controller?.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        child: SafeArea(
          bottom: false,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.red,
                                ),
                              ),
                              const Align(
                                child: Text(
                                  'Оплата картой',
                                  style: CustomTextStyle.black15w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Expanded(
                    // height: 400.h,
                    child: WebView(
                      initialUrl: widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onPageStarted: (url) {
                        print('object ${url}');
                        if (url.contains('Success')) {
                          Navigator.of(context).pop(true);
                          _controller?.loadUrl(widget.url);
                        } else if (url.contains('Fail')) {
                          Navigator.of(context).pop(false);
                          _controller?.loadUrl(widget.url);
                        }
                        // else {
                        //   Navigator.of(context).pop(false);
                        // }
                        // print('object $url');
                        // else if (url ==
                        //     'https://ws.egorka.dev/payment/tinkoff/redirect/?id=${widget.id}-${widget.pin}') {
                        //   Navigator.of(context).pop(false);
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
