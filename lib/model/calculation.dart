class Calculation {
  String? key;
  dynamic value;

  Calculation({this.key, this.value});

  Calculation.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }
}