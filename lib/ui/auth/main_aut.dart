import 'dart:async';
import 'package:egorka/ui/auth/auth_page.dart';
import 'package:flutter/material.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  PageController pageController = PageController();
  final streamController = StreamController<int>();

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<int>(
                  stream: streamController.stream,
                  initialData: 0,
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  snapshot.data == 0 ? Colors.grey[300] : null,
                            ),
                            child: const Icon(Icons.person, size: 40),
                          ),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            streamController.add(1);
                            pageController.jumpToPage(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  snapshot.data == 1 ? Colors.grey[300] : null,
                            ),
                            child:
                                const Icon(Icons.card_travel_sharp, size: 40),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 400,
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AuthPage(),
                  AuthPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
