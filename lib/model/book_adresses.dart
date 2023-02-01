class BookAdresses {
  String? id;
  String? code;
  String? name;
  String? address;
  String? entrance;
  String? floor;
  String? room;
  dynamic latitude;
  dynamic longitude;

  BookAdresses({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.entrance,
    required this.floor,
    required this.room,
    required this.latitude,
    required this.longitude,
  });

  factory BookAdresses.fromJson(Map<String, dynamic> data) {
    String id = data['ID'] ?? '';
    String code = data['Code'] ?? '';
    String name = data['Name'] ?? '';
    String address = data['Address'] ?? '';
    String entrance = data['Entrance'] ?? '';
    String floor = data['Floor'] ?? '';
    String room = data['Room'] ?? '';
    dynamic latitude = data['Latitude'] ?? '';
    dynamic longtitude = data['Longitude'] ?? '';
    return BookAdresses(
      id: id,
      code: code,
      name: name,
      address: address,
      entrance: entrance,
      floor: floor,
      room: room,
      latitude: latitude,
      longitude: longtitude,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['Name'] = name;
    data['Code'] = code;
    data['Entrance'] = entrance;
    data['Floor'] = floor;
    data['Room'] = room;
    return data;
  }
}
