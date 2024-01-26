import 'package:egorka/model/options.dart';
import 'package:egorka/model/payments.dart';

class InvoiceModel {
  String? time;
  int? timeStamp;
  String? timeZone;
  double? execution;
  String? method;
  Result? result;

  InvoiceModel({
    this.time,
    this.timeStamp,
    this.timeZone,
    this.execution,
    this.method,
    this.result,
  });

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    timeZone = json['TimeZone'];
    execution = json['Execution'];
    method = json['Method'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
  }
}

class Result {
  Invoice? invoice;

  Result({this.invoice});

  Result.fromJson(Map<String, dynamic> json) {
    invoice =
        json['Invoice'] != null ? Invoice.fromJson(json['Invoice']) : null;
  }
}

class Invoice {
  int? iD;
  int? pIN;
  int? date;
  int? dateStamp;
  int? dateUpdate;
  int? dateUpdateStamp;
  int? dateActual;
  int? dateActualStamp;
  dynamic dateExpire;
  dynamic dateExpireStamp;
  String? type;
  String? direction;
  dynamic externalID;
  dynamic externalNumber;
  List<dynamic> items = [];
  List<Options> options = [];
  List<Payments> payments = [];
  String? amount;
  String? currency;
  String? status;

  Invoice(
      {this.iD,
      this.pIN,
      this.date,
      this.dateStamp,
      this.dateUpdate,
      this.dateUpdateStamp,
      this.dateActual,
      this.dateActualStamp,
      this.dateExpire,
      this.dateExpireStamp,
      this.type,
      this.direction,
      this.externalID,
      this.externalNumber,
      this.items = const [],
      this.options = const [],
      this.payments = const [],
      this.amount,
      this.currency,
      this.status});

  Invoice.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    pIN = json['PIN'];
    date = json['Date'];
    dateStamp = json['DateStamp'];
    dateUpdate = json['DateUpdate'];
    dateUpdateStamp = json['DateUpdateStamp'];
    dateActual = json['DateActual'];
    dateActualStamp = json['DateActualStamp'];
    dateExpire = json['DateExpire'];
    dateExpireStamp = json['DateExpireStamp'];
    type = json['Type'];
    direction = json['Direction'];
    externalID = json['ExternalID'];
    externalNumber = json['ExternalNumber'];
    double amounttemp = json['Amount'] / 100;
    final arrayAmount = amounttemp.toString().split('.');
    String ends = arrayAmount.last.length == 1 ? '00' : arrayAmount.last;
    amount = '${arrayAmount.first}.$ends';
    currency = json['Currency'];
    status = json['Status'];
    json['Payments'].forEach((v) {
      payments.add(Payments.fromJson(v));
    });
    json['Options'].forEach((v) {
      options.add(Options.fromJson(v));
    });
  }
}
