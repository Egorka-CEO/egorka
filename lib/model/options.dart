class Options {
  String? logic;
  String? gate;
  String? type;
  int? amount;
  String? currency;
  String? status;

  Options(
      {this.logic,
      this.gate,
      this.type,
      this.amount,
      this.currency,
      this.status});

  Options.fromJson(Map<String, dynamic> json) {
    logic = json['Logic'];
    gate = json['Gate'];
    type = json['Type'];
    amount = json['Amount'];
    currency = json['Currency'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Logic'] = this.logic;
    data['Gate'] = this.gate;
    data['Type'] = this.type;
    data['Amount'] = this.amount;
    data['Currency'] = this.currency;
    data['Status'] = this.status;
    return data;
  }
}