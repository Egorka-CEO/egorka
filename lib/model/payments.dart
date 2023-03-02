import 'dart:developer';

class Payments {
  int? date;
  int? dateStamp;
  int? dateActual;
  int? dateActualStamp;
  String? gate;
  String? gateID;
  Account? account;
  int? amount;
  String? currency;
  String? status;

  Payments(
      {this.date,
      this.dateStamp,
      this.dateActual,
      this.dateActualStamp,
      this.gate,
      this.gateID,
      this.account,
      this.amount,
      this.currency,
      this.status});

  Payments.fromJson(Map<String, dynamic> json) {
    log('object $json');
    date = json['Date'];
    dateStamp = json['DateStamp'];
    dateActual = json['DateActual'];
    dateActualStamp = json['DateActualStamp'];
    gate = json['Gate'];
    gateID = json['GateID'];
    account =
        json['Account'] != null ? Account.fromJson(json['Account']) : null;
    amount = json['Amount'];
    currency = json['Currency'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['DateStamp'] = this.dateStamp;
    data['DateActual'] = this.dateActual;
    data['DateActualStamp'] = this.dateActualStamp;
    data['Gate'] = this.gate;
    data['GateID'] = this.gateID;
    if (this.account != null) {
      data['Account'] = this.account!.toJson();
    }
    data['Amount'] = this.amount;
    data['Currency'] = this.currency;
    data['Status'] = this.status;
    return data;
  }
}

class Account {
  String? iD;
  String? detail;
  int? balanceBefore;
  int? balanceAfter;

  Account({this.iD, this.detail, this.balanceBefore, this.balanceAfter});

  Account.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    detail = json['Detail'];
    balanceBefore = json['BalanceBefore'];
    balanceAfter = json['BalanceAfter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Detail'] = this.detail;
    data['BalanceBefore'] = this.balanceBefore;
    data['BalanceAfter'] = this.balanceAfter;
    return data;
  }
}
