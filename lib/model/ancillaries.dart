class Ancillaries {
  String? type;
  Params? params;

  Ancillaries(this.type, this.params);

  Ancillaries.fromJson(Map<String, dynamic> json) {
    type = json['ID'];
    params = Params.fromJson(json['Point']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['Params'] = params?.toJson();
    return data;
  }
}

class Params {
  int? count;
  int? count15;

  Params({this.count, this.count15});

  Params.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    count15 = json['Count15'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Count'] = count;
    data['Count15'] = count15;
    return data;
  }
}
