import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';

class MessageDialogs {
  void showMessage(String? from, String message) {
    SmartDialog.showToast(
      '',
      displayTime: const Duration(seconds: 3),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: Color.fromRGBO(26, 42, 97, 0.06),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              child: ListTile(
                minLeadingWidth: 10,
                leading: const Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                title: Text(from!),
                subtitle: Text(message),
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }

  void showAlert(String? from, String message) {
    SmartDialog.showToast('',
        displayTime: const Duration(seconds: 3),
        builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        spreadRadius: 3,
                        color: Color.fromRGBO(26, 42, 97, 0.06),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        MaterialCommunityIcons.information,
                        color: Colors.black,
                        size: 30,
                      ),
                      title: Text(from!),
                      subtitle: Text(message),
                    ),
                  ),
                ),
              ),
            ),
        alignment: Alignment.topLeft,
        maskColor: Colors.transparent);
  }

  void showLoadDialog(String text) {
    SmartDialog.show(
        maskColor: Colors.transparent,
        clickMaskDismiss: false,
        backDismiss: false,
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[300],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const CupertinoActivityIndicator(), Text(text)],
              ),
            ),
          );
        });
  }

  Future completeDialog({String text = ''}) async {
    await SmartDialog.show(
      clickMaskDismiss: false,
      builder: (context) {
        return DoneAnim(text);
      },
    );
  }

  Future errorDialog({String text = '', String error = ''}) async {
    await SmartDialog.show(
      clickMaskDismiss: false,
      builder: (context) {
        return ErrorAnim(text, error);
      },
    );
  }
}

class DoneAnim extends StatefulWidget {
  String text;

  DoneAnim(this.text);

  @override
  State<DoneAnim> createState() => _DoneAnimState();
}

class _DoneAnimState extends State<DoneAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;

  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        SmartDialog.dismiss();
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Center(
        child: Container(
          height: 300.h,
          width: 300.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Lottie.asset("assets/anim/done.json",
                      controller: lottieController,
                      repeat: false, onLoaded: (composition) {
                    lottieController.duration = composition.duration;
                    lottieController.forward();
                  }),
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorAnim extends StatefulWidget {
  String text;
  String error;

  ErrorAnim(this.text, this.error);

  @override
  State<ErrorAnim> createState() => _ErrorAnimState();
}

class _ErrorAnimState extends State<ErrorAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;

  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        SmartDialog.dismiss();
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Center(
        child: Container(
          height: 250.h,
          width: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Lottie.asset(
                    "assets/anim/fail.json",
                    controller: lottieController,
                    repeat: false,
                    onLoaded: (composition) {
                      lottieController.duration = composition.duration;
                      lottieController.forward();
                    },
                  ),
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.error,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
