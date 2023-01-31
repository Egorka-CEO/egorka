import 'dart:async';
import 'package:egorka/ui/auth/reg_page.dart';
import 'package:egorka/ui/auth/reg_page_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainRegPage extends StatefulWidget {
  final bool flag;
  const MainRegPage({super.key, required this.flag});

  @override
  State<MainRegPage> createState() => _MainRegPageState();
}

class _MainRegPageState extends State<MainRegPage> {
  late PageController pageController;
  final streamController = StreamController<int>();

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.flag ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: StreamBuilder<int>(
                  stream: streamController.stream,
                  initialData: widget.flag ? 0 : 1,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            streamController.add(0);
                            pageController.jumpToPage(0);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color:
                                  snapshot.data == 0 ? Colors.grey[300] : null,
                            ),
                            child: Icon(Icons.person, size: 40.w),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        GestureDetector(
                          onTap: () {
                            streamController.add(1);
                            pageController.jumpToPage(1);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color:
                                  snapshot.data == 1 ? Colors.grey[300] : null,
                            ),
                            child: Icon(Icons.card_travel_sharp, size: 40.w),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Expanded(
              child: SizedBox(
                // height: 400.h,
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RegPage(),
                    RegPageCompany(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
