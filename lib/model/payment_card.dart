class PaymentCard {
  int? iD;
  int? pIN;
  String? logic;
  String? url;
  String? status;

  PaymentCard({
    required this.iD,
    required this.pIN,
    required this.logic,
    required this.url,
    required this.status,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    final iD = json['ID'];
    final pIN = json['PIN'];
    final logic = json['Logic'];
    final url = json['URL'];
    final status = json['Status'];
    return PaymentCard(
      iD: iD,
      pIN: pIN,
      logic: logic,
      url: url,
      status: status,
    );
  }
}
