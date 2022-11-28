import 'package:egorka/model/address.dart';

class CoastResponse {
  CoastResponse(
    this.time,
    this.timeStamp,
    this.execution,
    this.method,
    this.result,
    this.errors,
  );

  String? time;
  int? timeStamp;
  double? execution;
  String? method;
  Result? result;
  List<Errors>? errors;

  CoastResponse.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
    if (json['Errors'] != null) {
      json['Errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }
}

class Result {
  Result(
    this.id,
    this.date,
    this.dateUpdate,
    this.stage,
    this.recordNumber,
    this.recordPin,
    this.recordDate,
    this.recordDateStamp,
    this.locations,
    this.ancillaries,
    this.calculation,
    this.totalPrice,
    this.status,
    this.statusPay,
  );

  String? id;
  int? date;
  int? dateUpdate;
  dynamic stage;
  int? recordNumber;
  int? recordPin;
  String? recordDate;
  int? recordDateStamp;
  List<Location>? locations;
  List<Ancillary>? ancillaries;
  List<Calculation>? calculation;
  TotalPrice? totalPrice;
  String? status;
  String? statusPay;

  Result.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    date = json['Date'];
    dateUpdate = json['DateUpdate'];
    stage = json['Stage'];
    recordNumber = json['RecordNumber'];
    recordPin = json['RecordPIN'];
    recordDate = json['RecordDate'];
    recordDateStamp = json['RecordDateStamp'];
    if (json['Locations'] != null) {
      json['Locations'].forEach((v) {
        locations!.add(Location.fromJson(v));
      });
    }
    if (json['Ancillaries'] != null) {
      json['Ancillaries'].forEach((v) {
        ancillaries!.add(Ancillary.fromJson(v));
      });
    }
    if (json['Calculation'] != null) {
      json['Calculation'].forEach((v) {
        calculation!.add(Calculation.fromJson(v));
      });
    }
    totalPrice = TotalPrice.fromJson(json['TotalPrice']);
    status = json['Status'];
    statusPay = json['StatusPay'];
  }
}

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

class Calculation {
  Calculation(
    this.key,
    this.value,
  );

  String? key;
  String? value;

  Calculation.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }
}

class Location {
  Location(
    this.id,
    this.externalId,
    this.externalData,
    this.key,
    this.num,
    this.date,
    this.dateTo,
    this.type,
    this.route,
    this.routeOrder,
    this.point,
    this.contact,
    this.message,
    this.params,
    this.status,
  );

  String? id;
  String? externalId;
  String? externalData;
  String? key;
  int? num;
  int? date;
  String? dateTo;
  String? type;
  int? route;
  int? routeOrder;
  Point? point;
  Contact? contact;
  String? message;
  List<dynamic>? params;
  String? status;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    key = json['Key'];
    num = json['Num'];
    date = json['Date'];
    type = json['Type'];
    route = json['Route'];
    routeOrder = json['RouteOrder'];
  }
}

class Contact {
  Contact({
    required this.name,
    required this.department,
    required this.phoneMobile,
    required this.phoneOffice,
    required this.phoneOfficeAdd,
    required this.emailPersonal,
    required this.emailOffice,
  });

  String name;
  String department;
  String phoneMobile;
  String phoneOffice;
  String phoneOfficeAdd;
  String emailPersonal;
  String emailOffice;
}

class Point {
  Point({
    required this.id,
    required this.address,
    required this.source,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.entrance,
    required this.floor,
    required this.room,
  });

  dynamic id;
  String address;
  String source;
  String code;
  double latitude;
  double longitude;
  String entrance;
  String floor;
  String room;
}

class TotalPrice {
  TotalPrice(
    this.base,
    this.ancillary,
    this.discount,
    this.bonus,
    this.tip,
    this.total,
    this.currency,
  );

  int? base;
  int? ancillary;
  int? discount;
  int? bonus;
  int? tip;
  int? total;
  String? currency;

  TotalPrice.fromJson(Map<String, dynamic> json) {
    base = json['Base'];
    ancillary = json['Ancillary'];
    discount = json['Discount'];
    bonus = json['Bonus'];
    tip = json['Tip'];
    total = json['Total'];
    currency = json['Currency'];
  }
}
