class AccountsDeposit {
  Result? result;

  AccountsDeposit({this.result});

  AccountsDeposit.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
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
}

class Accounts {
  String iD;
  int number;
  String key;
  int amount;
  int credit;
  String currency;
  String type;
  String status;

  Accounts({
    required this.iD,
    required this.number,
    required this.key,
    required this.amount,
    required this.credit,
    required this.currency,
    required this.type,
    required this.status,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) {
    String iD = json['ID'];
    int number = json['Number'];
    String key = json['Key'];
    int amount = json['Amount'];
    int credit = json['Credit'];
    String currency = json['Currency'];
    String type = json['Type'];
    String status = json['Status'];
    return Accounts(
      iD: iD,
      number: number,
      key: key,
      amount: amount,
      credit: credit,
      currency: currency,
      type: type,
      status: status,
    );
  }
}
