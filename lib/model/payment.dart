class Payment {
  String iD;
  String pIN;
  String gate;
  Return answer;

  Payment(
    this.iD,
    this.pIN,
    this.gate,
    this.answer,
  );

  factory Payment.fromJson(Map<String, dynamic> json) {
    final iD = json['ID'];
    final pIN = json['PIN'];
    final gate = json['Gate'];
    final answer = Return.fromJson(json['Return']);
    return Payment(iD, pIN, gate, answer);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['PIN'] = pIN;
    data['Gate'] = gate;
    data['Return'] = answer.toJson();
    return data;
  }
}

class Return {
  String success;
  String failure;
  String pending;

  Return(this.success, this.failure, this.pending,);

  factory Return.fromJson(Map<String, dynamic> json) {
    final success = json['Success'];
    final failure = json['Failure'];
    final pending = json['Pending'];
    return Return(success, failure, pending);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Failure'] = failure;
    data['Pending'] = pending;
    return data;
  }
}
