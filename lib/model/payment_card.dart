class PaymentCard {
  String iD;
  String pIN;
  String gate;
  Return? answer;

  PaymentCard({
    required this.iD,
    required this.pIN,
    required this.gate,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['PIN'] = pIN;
    data['Gate'] = gate;
    if (answer != null) {
      data['Return'] = answer?.toJson();
    }
    return data;
  }
}

class Return {
  String success;
  String failure;
  String pending;

  Return({
    required this.success,
    required this.failure,
    required this.pending,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Failure'] = failure;
    data['Pending'] = pending;
    return data;
  }
}
