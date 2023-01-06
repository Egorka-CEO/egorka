import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/locations.dart';

class CoastAdvanced {
  String? iD;
  String? type;
  List<Location>? locations;
  List<Ancillaries>? ancillaries = [];
  String? description;

  CoastAdvanced({
    this.iD,
    this.type,
    this.locations,
    this.ancillaries,
    this.description,
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
    if (json['Ancillaries'] != null) {
      ancillaries = <Ancillaries>[];
      json['Ancillaries'].forEach((v) {
        ancillaries!.add(Ancillaries.fromJson(v));
      });
    }
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    data['Description'] = description;
    data['Locations'] = locations?.map((e) => e.toJson()).toList();
    data['Ancillaries'] = ancillaries?.map((e) => e.toJson()).toList();
    return data;
  }
}
