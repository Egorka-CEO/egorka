class DepositTraffic {
  int number;
  DateTime dateCreation;
  DateTime datePayment;
  String comment;
  String rubles;
  String status;

  DepositTraffic({
    required this.number,
    required this.dateCreation,
    required this.datePayment,
    required this.comment,
    required this.rubles,
    required this.status,
  });
}
