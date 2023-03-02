import 'package:egorka/model/address.dart';

class PointMarketPlace {
  String? iD;
  String? type;
  String? code;
  double? latitude;
  double? longitude;
  List<Name>? name = [];
  List<Address>? address = [];

  PointMarketPlace(
      {this.iD,
      this.type,
      this.code,
      this.latitude,
      this.longitude,
      this.name,
      this.address});

  PointMarketPlace.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    code = json['Code'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    if (json['Name'] != null) {
      json['Name'].forEach((v) {
        name!.add(Name.fromJson(v));
      });
    }
  }
}

class Name {
  String? name;
  String? language;

  Name({this.name, this.language});

  Name.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    language = json['Language'];
  }
}
