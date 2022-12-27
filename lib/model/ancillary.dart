import 'package:egorka/model/calculation.dart';

class Ancillary {
  Ancillary(
    this.id,
    this.type,
    this.locations,
    this.cargoId,
    this.goodsId,
    this.price,
    this.currency,
    this.courierPrice,
    this.courierCurrency,
    this.params,
    this.status,
    this.statusPay,
  );

  String? id;
  String? type;
  List<dynamic>? locations;
  dynamic cargoId;
  dynamic goodsId;
  int? price;
  String? currency;
  int? courierPrice;
  String? courierCurrency;
  List<Calculation>? params;
  String? status;
  String? statusPay;

  Ancillary.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    type = json['Type'];
    price = json['Price'];
    currency = json['Currency'];
    courierPrice = json['CourierPrice'];
    courierCurrency = json['CourierCurrency'];
    status = json['Status'];
    statusPay = json['StatusPay'];
  }
}
