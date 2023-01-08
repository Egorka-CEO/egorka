class Cargos {
  String? type;

  Cargos(this.type);

  Cargos.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    return data;
  }
}
