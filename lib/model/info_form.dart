import 'package:egorka/model/ancillary.dart';
import 'package:egorka/model/calculation.dart';
import 'package:egorka/model/courier.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/total_price.dart';

class InfoForm {
  String? time;
  int? timeStamp;
  double? execution;
  String? method;
  Result? result;
  Null? errors;

  InfoForm(
      {this.time,
      this.timeStamp,
      this.execution,
      this.method,
      this.result,
      this.errors});

  InfoForm.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
    errors = json['Errors'];
  }
}

class Result {
  String? iD;
  int? date;
  int? dateUpdate;
  String? type;
  String? group;
  String? stage;
  int? recordNumber;
  int? recordPIN;
  String? recordKey;
  String? recordDate;
  int? recordDateStamp;
  String? recordExpireDate;
  int? recordExpireDateStamp;
  Courier? courier;
  List<Location>? locations;
  List<Ancillary>? ancillaries;
  String? message;
  List<Calculation>? calculation;
  TotalPrice? totalPrice;
  dynamic payDate;
  dynamic payDateStamp;
  String? payStatus;
  String? status;
  String? description;
  List<Invoice>? invoices;

  Result(
      {this.iD,
      this.date,
      this.dateUpdate,
      this.type,
      this.group,
      this.stage,
      this.recordNumber,
      this.recordPIN,
      this.recordKey,
      this.recordDate,
      this.recordDateStamp,
      this.recordExpireDate,
      this.recordExpireDateStamp,
      this.courier,
      this.locations,
      this.ancillaries,
      this.message,
      this.calculation,
      this.totalPrice,
      this.payDate,
      this.payDateStamp,
      this.payStatus,
      this.status,
      this.invoices,
      this.description});

  Result.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    date = json['Date'];
    dateUpdate = json['DateUpdate'];
    type = json['Type'];
    group = json['Group'];
    stage = json['Stage'];
    recordNumber = json['RecordNumber'];
    recordPIN = json['RecordPIN'];
    recordKey = json['RecordKey'];
    recordDate = json['RecordDate'];
    recordDateStamp = json['RecordDateStamp'];
    recordExpireDate = json['RecordExpireDate'];
    recordExpireDateStamp = json['RecordExpireDateStamp'];
    description = json['Description'];
    courier =
        json['Courier'] != null ? Courier.fromJson(json['Courier']) : null;
    if (json['Locations'] != null) {
      locations = <Location>[];
      json['Locations'].forEach((v) {
        locations!.add(Location.fromJson(v));
      });
    }
    if (json['Ancillaries'] != null) {
      ancillaries = <Ancillary>[];
      json['Ancillaries'].forEach((v) {
        ancillaries!.add(Ancillary.fromJson(v));
      });
    }
    message = json['Message'];
    if (json['Calculation'] != null) {
      calculation = <Calculation>[];
      json['Calculation'].forEach((v) {
        calculation!.add(Calculation.fromJson(v));
      });
    }
    totalPrice = json['TotalPrice'] != null
        ? TotalPrice.fromJson(json['TotalPrice'])
        : null;
    payDate = json['PayDate'];
    payDateStamp = json['PayDateStamp'];
    payStatus = json['PayStatus'];
    status = json['Status'];
    if (json['Invoices'] != null) {
      invoices = <Invoice>[];
      json['Invoices'].forEach((v) {
        invoices!.add(Invoice.fromJson(v));
      });
    }
  }
}
