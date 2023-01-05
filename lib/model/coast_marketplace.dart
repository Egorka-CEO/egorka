import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/locations.dart';

class CoastMarketPlace {
  String? iD;
  String? type;
  String? group;
  List<Location>? locations;
  List<Ancillaries>? ancillaries;
  String? description;
  String? message;

  CoastMarketPlace({
    this.iD,
    this.type,
    this.group,
    this.locations,
    this.ancillaries,
    this.description,
    this.message,
  });

  CoastMarketPlace.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    group = json['Group'];
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
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['Type'] = type;
    data['Group'] = group;
    data['Description'] = description;
    data['Message'] = message;
    data['Locations'] = locations!.map((e) => e.toJson()).toList();
    data['Ancillaries'] = ancillaries!.map((e) => e.toJson()).toList();
    return data;
  }
}
