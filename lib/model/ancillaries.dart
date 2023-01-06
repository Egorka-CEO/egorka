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
  int? amount;
  String? weight;
  String? width;
  String? height;
  String? depth;
  String? address;
  String? name;
  String? point;
  String? number;
  String? phone;

  Params({
    this.count,
    this.count15,
    this.amount,
    this.weight,
    this.width,
    this.height,
    this.depth,
    this.address,
    this.name,
    this.point,
    this.number,
    this.phone,
  });

  Params.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    count15 = json['Count15'];
    amount = json['Amount'];
    weight = json['Weight'];
    width = json['Width'];
    height = json['Height'];
    depth = json['Depth'];
    address = json['Address'];
    name = json['Name'];
    point = json['Point'];
    number = json['Number'];
    phone = json['Phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (count != null) data['Count'] = count;
    if (count15 != null) data['Count15'] = count15;
    if (amount != null) data['Amount'] = amount;
    if (weight != null) data['Weight'] = weight;
    if (width != null) data['Width'] = width;
    if (height != null) data['Height'] = height;
    if (depth != null) data['Depth'] = depth;
    if (address != null) data['Address'] = address;
    if (name != null) data['Name'] = name;
    if (point != null) data['Point'] = point;
    if (number != null) data['Number'] = number;
    if (phone != null) data['Phone'] = phone;
    return data;
  }
}
