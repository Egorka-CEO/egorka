import 'package:egorka/model/locations.dart';

class CoastAdvanced {
  String? iD;
  String? type;
  List<Location>? locations;

  CoastAdvanced({
    this.iD,
    this.type,
    this.locations,
  });

  CoastAdvanced.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    if (json['Locations'] != null) {
      locations = <Location>[];
      json['Locations'].forEach((v) {
        locations!.add(Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    data['Locations'] = locations!.map((e) => e.toJson()).toList();
    return data;
  }
}
