class Items {
  int? date;
  int? dateStamp;
  String? iD;
  String? type;
  Null gate;
  Null recordID;
  String? recordNumber;
  int? recordDate;
  Null recordDateStamp;
  Null recordExpireDate;
  Null recordExpireDateStamp;
  int? amount;
  String? currency;
  String? status;

  Items(
      {this.date,
      this.dateStamp,
      this.iD,
      this.type,
      this.gate,
      this.recordID,
      this.recordNumber,
      this.recordDate,
      this.recordDateStamp,
      this.recordExpireDate,
      this.recordExpireDateStamp,
      this.amount,
      this.currency,
      this.status});

  Items.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    dateStamp = json['DateStamp'];
    iD = json['ID'];
    type = json['Type'];
    gate = json['Gate'];
    recordID = json['RecordID'];
    recordNumber = json['RecordNumber'];
    recordDate = json['RecordDate'];
    recordDateStamp = json['RecordDateStamp'];
    recordExpireDate = json['RecordExpireDate'];
    recordExpireDateStamp = json['RecordExpireDateStamp'];
    amount = json['Amount'];
    currency = json['Currency'];
    status = json['Status'];
  }
}