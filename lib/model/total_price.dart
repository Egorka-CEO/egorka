class TotalPrice {
  int? base;
  int? ancillary;
  int? discount;
  int? compensation;
  int? bonus;
  int? tip;
  String? total;
  String? currency;

  TotalPrice(
      {this.base,
      this.ancillary,
      this.discount,
      this.compensation,
      this.bonus,
      this.tip,
      this.total,
      this.currency});

  TotalPrice.fromJson(Map<String, dynamic> json) {
    base = json['Base'];
    ancillary = json['Ancillary'];
    discount = json['Discount'];
    compensation = json['Compensation'];
    bonus = json['Bonus'];
    tip = json['Tip'];
    double amountDouble = double.parse('${json['Total']}')/100;
    final str = amountDouble.toString().split('.');
    total = '${str.first}.${str.last.length == 1 ? str.last[0] == '0' ? '00' : '${str.last}0' : str.last}';
    currency = json['Currency'];
  }
}
