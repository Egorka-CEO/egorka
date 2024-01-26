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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    data['DateStamp'] = dateStamp;
    data['DateActual'] = dateActual;
    data['DateActualStamp'] = dateActualStamp;
    data['Gate'] = gate;
    data['GateID'] = gateID;
    if (account != null) {
      data['Account'] = account!.toJson();
    }
    data['Amount'] = amount;
    data['Currency'] = currency;
    data['Status'] = status;
    return data;
  }
}

class Account {
  String? id;
  String? detail;
  int? balanceBefore;
  int? balanceAfter;

  Account({this.id, this.detail, this.balanceBefore, this.balanceAfter});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    detail = json['Detail'];
    balanceBefore = json['BalanceBefore'];
    balanceAfter = json['BalanceAfter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Detail'] = detail;
    data['BalanceBefore'] = balanceBefore;
    data['BalanceAfter'] = balanceAfter;
    return data;
  }
}
