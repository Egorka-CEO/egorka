import 'package:egorka/model/ancillary.dart';
import 'package:egorka/model/locations.dart';

class CoastBase {
  String? iD;
  String? type;
  List<Location>? locations;
  List<Ancillary>? ancillaries;
  String? description;
  String? message;

  CoastBase({
    this.iD,
    this.type,
    this.locations,
    this.ancillaries,
    this.description,
    this.message,
  });

  CoastBase.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    if (json['Locations'] != null) {
      locations = <Location>[];
      json['Locations'].forEach((v) {
        locations!.add(Location.fromJson(v));
      });
    }
    if (json['Ancillaries'] != null) {
      ancillaries = <Ancillary>[];
      json['Ancillaries'].forEach((v) {
        ancillaries!.add(Ancillary.fromJson(v));
      });
    }
    description = json['Description'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['Type'] = type;
    data['Locations'] = locations!.map((e) => e.toJson()).toList();

    return data;
  }
}
