class CoastBase {
  String? iD;
  String? type;
  List<Locations>? locations;
  List<Ancillaries>? ancillaries;
  Promo? promo;
  String? description;
  String? message;

  CoastBase({
    this.iD,
    this.type,
    this.locations,
    this.ancillaries,
    this.promo,
    this.description,
    this.message,
  });

  CoastBase.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    if (json['Locations'] != null) {
      locations = <Locations>[];
      json['Locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
    if (json['Ancillaries'] != null) {
      ancillaries = <Ancillaries>[];
      json['Ancillaries'].forEach((v) {
        ancillaries!.add(Ancillaries.fromJson(v));
      });
    }
    promo = json['Promo'] != null ? Promo.fromJson(json['Promo']) : null;
    description = json['Description'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    if (locations != null) {
      data['Locations'] = locations!.map((v) => v.toJson()).toList();
    }
    if (ancillaries != null) {
      data['Ancillaries'] = ancillaries!.map((v) => v.toJson()).toList();
    }
    if (promo != null) {
      data['Promo'] = promo!.toJson();
    }
    data['Description'] = description;
    data['Message'] = message;
    return data;
  }
}

class Locations {
  String? date;
  Point? point;
  Contact? contact;
  String? message;

  Locations({
    this.date,
    this.point,
    this.contact,
    this.message,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    point = json['Point'] != null ? Point.fromJson(json['Point']) : null;
    contact =
        json['Contact'] != null ? Contact.fromJson(json['Contact']) : null;
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    if (point != null) {
      data['Point'] = point!.toJson();
    }
    if (contact != null) {
      data['Contact'] = contact!.toJson();
    }
    data['Message'] = message;
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
    this.phoneOfficeAdd,}
  );

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

class Ancillaries {
  String? type;
  List<String>? params;

  Ancillaries({
    this.type,
    this.params,
  });

  Ancillaries.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    if (json['Params'] != null) {
      params = [];
      json['Params'].forEach((v) {
        params!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    if (params != null) {
      data['Params'] = params!.map((v) => v).toList();
    }
    return data;
  }
}

class Promo {
  String? code;

  Promo({
    this.code,
  });

  Promo.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    return data;
  }
}
