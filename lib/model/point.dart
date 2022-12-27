class Point {
  Point({
    this.id,
    this.address,
    this.source,
    this.code,
    this.latitude,
    this.longitude,
    this.entrance,
    this.floor,
    this.room,
  });

  dynamic id;
  String? address;
  String? source;
  String? code;
  dynamic latitude;
  dynamic longitude;
  String? entrance;
  String? floor;
  String? room;

  Point.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    address = json['Address'];
    source = json['Source'];
    code = json['Code'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    entrance = json['Entrance'];
    floor = json['Floor'];
    room = json['Room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Address'] = address;
    data['Source'] = source;
    data['Code'] = code ?? '$latitude,$longitude';
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['Entrance'] = entrance;
    data['Floor'] = floor;
    data['Room'] = room;
    return data;
  }
}
