import 'package:egorka/model/address.dart';
import 'package:egorka/model/ancillary.dart';
import 'package:egorka/model/calculation.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/total_price.dart';

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
      errors = [];
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
      locations = [];
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
      calculation = [];
      json['Calculation'].forEach((v) {
        calculation!.add(Calculation.fromJson(v));
      });
    }
    totalPrice = TotalPrice.fromJson(json['TotalPrice']);
    status = json['Status'];
    statusPay = json['StatusPay'];
  }
}
