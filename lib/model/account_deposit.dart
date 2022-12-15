class AccountsDeposit {
  Result? result;

  AccountsDeposit({this.result});

  AccountsDeposit.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Accounts> accounts;

  Result({required this.accounts});

  factory Result.fromJson(Map<String, dynamic> json) {
    List<Accounts> account = <Accounts>[];
    if (json['Accounts'] != null) {
      json['Accounts'].forEach((v) {
        account.add(Accounts.fromJson(v));
      });
    }
    return Result(accounts: account);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accounts.isNotEmpty) {
      data['Accounts'] = accounts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accounts {
  String iD;
  int number;
  int amount;
  int credit;
  String currency;
  String type;
  String status;

  Accounts({
    required this.iD,
    required this.number,
    required this.amount,
    required this.credit,
    required this.currency,
    required this.type,
    required this.status,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) {
    String iD = json['ID'];
    int number = json['Number'];
    int amount = json['Amount'];
    int credit = json['Credit'];
    String currency = json['Currency'];
    String type = json['Type'];
    String status = json['Status'];
    return Accounts(
      iD: iD,
      number: number,
      amount: amount,
      credit: credit,
      currency: currency,
      type: type,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Number'] = number;
    data['Amount'] = amount;
    data['Credit'] = credit;
    data['Currency'] = currency;
    data['Type'] = type;
    data['Status'] = status;
    return data;
  }
}
