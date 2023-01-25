import 'package:egorka/model/point.dart';

class Suggestions {
  String? iD;
  String name;
  Point? point;
  String? houseNumber;

  Suggestions({
    required this.iD,
    required this.name,
    required this.point,
    this.houseNumber,
  });

  factory Suggestions.fromJson(Map<String, dynamic> json) {
    final iD = json['ID'];
    final name = json['Name'];
    final point = json['Point'] != null ? Point.fromJson(json['Point']) : null;
    return Suggestions(iD: iD, name: name, point: point);
  }
}