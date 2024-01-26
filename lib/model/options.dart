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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Logic'] = logic;
    data['Gate'] = gate;
    data['Type'] = type;
    data['Amount'] = amount;
    data['Currency'] = currency;
    data['Status'] = status;
    return data;
  }
}