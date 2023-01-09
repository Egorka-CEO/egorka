import 'package:egorka/model/contact.dart';
import 'package:egorka/model/point.dart';

class Location {
  Location({
    this.id,
    this.externalId,
    this.externalData,
    this.key,
    this.num,
    this.date,
    this.dateTo,
    this.type,
    this.route,
    this.routeOrder,
    this.point,
    this.contact,
    this.message,
    this.params,
    this.status,}
  );

  String? id;
  String? externalId;
  String? externalData;
  String? key;
  int? num;
  dynamic date;
  String? dateTo;
  String? type;
  int? route;
  int? routeOrder;
  Point? point;
  Contact? contact;
  String? message;
  List<dynamic>? params;
  String? status;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    key = json['Key'];
    num = json['Num'];
    date = json['Date'];
    type = json['Type'];
    route = json['Route'];
    point = Point.fromJson(json['Point']);
    contact = Contact.fromJson(json['Contact']);
    routeOrder = json['RouteOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Key'] = key;
    data['Num'] = num;
    data['Date'] = date;
    data['Type'] = type;
    data['Route'] = route;
    data['Point'] = point!.toJson();
    data['Contact'] = contact?.toJson();
    return data;
  }
}
