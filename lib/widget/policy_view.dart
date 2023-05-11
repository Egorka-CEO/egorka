import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolicyView extends StatefulWidget {
  @override
  State<PolicyView> createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  Uint8List? pdfFile;

  @override
  void initState() {
    super.initState();
    loadDB();
  }

  void loadDB() async {
    var data = await rootBundle.load('assets/files/policy.pdf');
    pdfFile = data.buffer.asUint8List();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfFile == null
          ? CupertinoActivityIndicator()
          : SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 10.h,
                    ),
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
                                  'Политика конфиденциальности',
                                  style: CustomTextStyle.black17w400,
                                ),
                              ),
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
                  Container(
                    height: MediaQuery.of(context).size.height - 89.h,
                    color: Colors.white,
                    child: PDFView(
                      pdfData: pdfFile,
                      onRender: (pages) {},
                      onError: (error) {},
                      onPageError: (page, error) {},
                      onViewCreated: (pdfViewController) {},
                      onPageChanged: (page, total) {},
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
