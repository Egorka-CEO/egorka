class CoastAdvanced {
  String? iD;
  String? type;
  List<Locations>? locations;

  CoastAdvanced({
    this.iD,
    this.type,
    this.locations,
  });

  CoastAdvanced.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    if (json['Locations'] != null) {
      locations = <Locations>[];
      json['Locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    if (locations != null) {
      data['Locations'] = locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  String? iD;
  String? type;
  String? date;
  String? route;
  String? routeOrder;
  Point? point;
  Contact? contact;

  Locations({
    this.iD,
    this.type,
    this.date,
    this.route,
    this.routeOrder,
    this.point,
    this.contact,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    date = json['Date'];
    route = json['Route'];
    routeOrder = json['RouteOrder'];
    point = json['Point'] != null ? Point.fromJson(json['Point']) : null;
    contact =
        json['Contact'] != null ? Contact.fromJson(json['Contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    data['Date'] = date;
    data['Route'] = route;
    data['RouteOrder'] = routeOrder;
    if (point != null) {
      data['Point'] = point!.toJson();
    }
    if (contact != null) {
      data['Contact'] = contact!.toJson();
    }
    return data;
  }
}

class Point {
  String? code;
  String? entrance;
  String? floor;
  String? room;

  Point({
    this.code,
    this.entrance,
    this.floor,
    this.room,
  });

  Point.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    entrance = json['Entrance'];
    floor = json['Floor'];
    room = json['Room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Entrance'] = entrance;
    data['Floor'] = floor;
    data['Room'] = room;
    return data;
  }
}

class Contact {
  String? name;
  String? phoneMobile;
  String? phoneOffice;
  String? phoneOfficeAdd;

  Contact({
    this.name,
    this.phoneMobile,
    this.phoneOffice,
    this.phoneOfficeAdd,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phoneMobile = json['PhoneMobile'];
    phoneOffice = json['PhoneOffice'];
    phoneOfficeAdd = json['PhoneOfficeAdd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['PhoneMobile'] = phoneMobile;
    data['PhoneOffice'] = phoneOffice;
    data['PhoneOfficeAdd'] = phoneOfficeAdd;
    return data;
  }
}
