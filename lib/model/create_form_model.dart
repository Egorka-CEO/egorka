import 'package:egorka/model/address.dart';
import 'package:egorka/model/calculation.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/total_price.dart';

class CreateFormModel {
  CreateFormModel({
    required this.time,
    required this.timeStamp,
    required this.execution,
    required this.method,
    required this.result,
    required this.errors,
  });
  late final String? time;
  late final int? timeStamp;
  late final double? execution;
  late final String? method;
  late final Result result;
  late final Errors? errors;

  CreateFormModel.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = Result.fromJson(json['Result']);
    if (json['Errors'] != null) {
      errors = Errors.fromJson(json['Errors']);
    }
  }
}

class Result {
  Result({
    required this.id,
    required this.type,
    required this.group,
    required this.date,
    required this.dateUpdate,
    this.stage,
    required this.recordNumber,
    required this.recordPIN,
    required this.recordKey,
    required this.recordDate,
    required this.recordDateStamp,
    required this.recordPriceDate,
    required this.recordPriceDateStamp,
    required this.recordExpireDate,
    this.recordExpireDateStamp,
    required this.locations,
    required this.ancillaries,
    required this.calculation,
    required this.totalPrice,
    required this.status,
    required this.statusPay,
  });
  String? id;
  String? type;
  String? group;
  int? date;
  int? dateUpdate;
  String? stage;
  int? recordNumber;
  int? recordPIN;
  String? recordKey;
  String? recordDate;
  int? recordDateStamp;
  String? recordPriceDate;
  int? recordPriceDateStamp;
  String? recordExpireDate;
  int? recordExpireDateStamp;
  List<Location> locations = [];
  List<dynamic> ancillaries = [];
  List<Calculation> calculation = [];
  TotalPrice? totalPrice;
  String? status;
  String? statusPay;

  Result.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    type = json['Type'];
    group = json['Group'];
    date = json['Date'];
    dateUpdate = json['DateUpdate'];
    stage = null;
    recordNumber = json['RecordNumber'];
    recordPIN = json['RecordPIN'];
    recordKey = json['RecordKey'];
    recordDate = json['RecordDate'];
    recordDateStamp = json['RecordDateStamp'];
    recordPriceDate = json['RecordPriceDate'];
    recordPriceDateStamp = json['RecordPriceDateStamp'];
    recordExpireDate = json['RecordExpireDate'];
    recordExpireDateStamp = null;
    locations =
        List.from(json['Locations']).map((e) => Location.fromJson(e)).toList();
    ancillaries = List.castFrom<dynamic, dynamic>(json['Ancillaries']);
    calculation = json['Calculation'] != null
        ? List.from(json['Calculation'])
            .map((e) => Calculation.fromJson(e))
            .toList()
        : [];
    totalPrice = TotalPrice.fromJson(json['TotalPrice']);
    status = json['Status'];
    statusPay = json['StatusPay'];
  }
}
