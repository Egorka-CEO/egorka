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
    required this.ID,
    required this.Group,
    required this.Date,
    required this.DateUpdate,
    this.Stage,
    required this.RecordNumber,
    required this.RecordPIN,
    required this.RecordKey,
    required this.RecordDate,
    required this.RecordDateStamp,
    required this.RecordPriceDate,
    required this.RecordPriceDateStamp,
    required this.RecordExpireDate,
    this.RecordExpireDateStamp,
    required this.locations,
    required this.Ancillaries,
    required this.calculation,
    required this.totalPrice,
    required this.Status,
    required this.StatusPay,
  });
  String? ID;
  String? Group;
  int? Date;
  int? DateUpdate;
  String? Stage;
  int? RecordNumber;
  int? RecordPIN;
  String? RecordKey;
  String? RecordDate;
  int? RecordDateStamp;
  String? RecordPriceDate;
  int? RecordPriceDateStamp;
  String? RecordExpireDate;
  int? RecordExpireDateStamp;
  List<Location> locations = [];
  List<dynamic> Ancillaries = [];
  List<Calculation> calculation = [];
  TotalPrice? totalPrice;
  String? Status;
  String? StatusPay;

  Result.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    Group = json['Group'];
    Date = json['Date'];
    DateUpdate = json['DateUpdate'];
    Stage = null;
    RecordNumber = json['RecordNumber'];
    RecordPIN = json['RecordPIN'];
    RecordKey = json['RecordKey'];
    RecordDate = json['RecordDate'];
    RecordDateStamp = json['RecordDateStamp'];
    RecordPriceDate = json['RecordPriceDate'];
    RecordPriceDateStamp = json['RecordPriceDateStamp'];
    RecordExpireDate = json['RecordExpireDate'];
    RecordExpireDateStamp = null;
    locations =
        List.from(json['Locations']).map((e) => Location.fromJson(e)).toList();
    Ancillaries = List.castFrom<dynamic, dynamic>(json['Ancillaries']);
    calculation = List.from(json['Calculation'])
        .map((e) => Calculation.fromJson(e))
        .toList();
    totalPrice = TotalPrice.fromJson(json['TotalPrice']);
    Status = json['Status'];
    StatusPay = json['StatusPay'];
  }
}
