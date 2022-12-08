import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class MessageDialogs {
  void showMessage(String? from, String message) {
    SmartDialog.showToast(
      '',
      displayTime: const Duration(seconds: 3),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }

  void showAlert(String? from, String message) {
    SmartDialog.showToast('',
        displayTime: const Duration(seconds: 3),
        builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
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
        alignment: Alignment.topLeft,
        maskColor: Colors.transparent);
  }
  //TODO прикрутить логику вывода алертов с Валерой

  // String _getStatus(String message) {
  //   if (message == 'cancel booking') {
  //     return 'Ваша бронь была отменена';
  //   }

  // }
}
