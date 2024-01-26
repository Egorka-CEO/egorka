class Courier {
  String? id;
  int? date;
  int? dateUpdate;
  String? dSID;
  List<String?> types;
  String? name;
  String? surname;
  String? patronymic;
  String? photo;
  String? password;
  String? carVendor;
  String? carModel;
  String? carNumber;
  String? carColor;
  String? carColorName;
  Vehicle? vehicle;
  List<Phones?> phones;
  List<dynamic> params;
  String? status;

  Courier({
    this.id,
    this.date,
    this.dateUpdate,
    this.dSID,
    this.types = const [],
    this.name,
    this.surname,
    this.patronymic,
    this.photo,
    this.password,
    this.carVendor,
    this.carModel,
    this.carNumber,
    this.carColor,
    this.carColorName,
    this.vehicle,
    this.phones = const [],
    this.params = const [],
    this.status,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    String? id = json['ID'];
    int? date = json['Date'];
    int? dateUpdate = json['DateUpdate'];
    String? dSID = json['DSID'];
    List<String?> types = json['Types'].cast<String>();
    String? name = json['Name'];
    String? surname = json['Surname'];
    String? patronymic = json['Patronymic'];
    String? photo = json['Photo'];
    String? password = json['Password'];
    String? carVendor = json['CarVendor'];
    String? carModel = json['CarModel'];
    String? carNumber = json['CarNumber'];
    String? carColor = json['CarColor'];
    String? carColorName = json['CarColorName'];
    Vehicle? vehicle =
        json['Vehicle'] != null ? Vehicle.fromJson(json['Vehicle']) : null;
    List<Phones?> phones = [];
    if (json['Phones'] != null) {
      json['Phones'].forEach((v) {
        phones.add(Phones.fromJson(v));
      });
    }
    List<dynamic> params = [];
    if (json['Params'] != null) {
      json['Params'].forEach((v) {
        params.add(v);
      });
    }
    String? status = json['Status'];
    return Courier(
      id: id,
      date: date,
      dateUpdate: dateUpdate,
      dSID: dSID,
      types: types,
      name: name,
      surname: surname,
      patronymic: patronymic,
      photo: photo,
      password: password,
      carVendor: carVendor,
      carModel: carModel,
      carNumber: carNumber,
      carColor: carColor,
      carColorName: carColorName,
      vehicle: vehicle,
      phones: phones,
      params: params,
      status: status,
    );
  }
}

class Vehicle {
  String? vendor;
  String? model;
  String? number;
  String? color;
  String? colorName;

  Vehicle({
    this.vendor,
    this.model,
    this.number,
    this.color,
    this.colorName,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    String? vendor = json['Vendor'];
    String? model = json['Model'];
    String? number = json['Number'];
    String? color = json['Color'];
    String? colorName = json['ColorName'];
    return Vehicle(
      vendor: vendor,
      model: model,
      number: number,
      color: color,
      colorName: colorName,
    );
  }
}

class Phones {
  String? value;
  List<dynamic> types;
  String? status;

  Phones({
    this.value,
    this.types = const [],
    this.status,
  });

  factory Phones.fromJson(Map<String, dynamic> json) {
    String? value = json['Value'];
    List<dynamic> types = [];
    if (json['Types'] != null) {
      json['Types'].forEach((v) {
        types.add(v);
      });
    }
    String? status = json['Status'];
    return Phones(
      value: value,
      types: types,
      status: status,
    );
  }
}
