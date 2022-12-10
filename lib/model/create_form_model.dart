class CreateFormModel {
  CreateFormModel({
    required this.time,
    required this.timeStamp,
    required this.execution,
    required this.method,
    required this.result,
    this.errors,
  });
  late final String time;
  late final int timeStamp;
  late final double execution;
  late final String method;
  late final Result result;
  late final Null errors;

  CreateFormModel.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = Result.fromJson(json['Result']);
    errors = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Time'] = time;
    _data['TimeStamp'] = timeStamp;
    _data['Execution'] = execution;
    _data['Method'] = method;
    _data['Result'] = result.toJson();
    _data['Errors'] = errors;
    return _data;
  }
}

class Result {
  Result({
    required this.ID,
    required this.Date,
    required this.DateUpdate,
    this.Stage,
    required this.RecordNumber,
    required this.RecordPIN,
    required this.RecordKey,
    required this.RecordDate,
    required this.RecordDateStamp,
    required this.RecordPriceDate,
    required this.RecordPriceDateStamp,
    required this.RecordExpireDate,
    this.RecordExpireDateStamp,
    required this.locations,
    required this.Ancillaries,
    required this.calculation,
    required this.totalPrice,
    required this.Status,
    required this.StatusPay,
  });
  late final String ID;
  late final int Date;
  late final int DateUpdate;
  late final Null Stage;
  late final int RecordNumber;
  late final int RecordPIN;
  late final String RecordKey;
  late final String RecordDate;
  late final int RecordDateStamp;
  late final String RecordPriceDate;
  late final int RecordPriceDateStamp;
  late final String RecordExpireDate;
  late final Null RecordExpireDateStamp;
  late final List<Locations> locations;
  late final List<dynamic> Ancillaries;
  late final List<Calculation> calculation;
  late final TotalPrice totalPrice;
  late final String Status;
  late final String StatusPay;

  Result.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    Date = json['Date'];
    DateUpdate = json['DateUpdate'];
    Stage = null;
    RecordNumber = json['RecordNumber'];
    RecordPIN = json['RecordPIN'];
    RecordKey = json['RecordKey'];
    RecordDate = json['RecordDate'];
    RecordDateStamp = json['RecordDateStamp'];
    RecordPriceDate = json['RecordPriceDate'];
    RecordPriceDateStamp = json['RecordPriceDateStamp'];
    RecordExpireDate = json['RecordExpireDate'];
    RecordExpireDateStamp = null;
    locations =
        List.from(json['Locations']).map((e) => Locations.fromJson(e)).toList();
    Ancillaries = List.castFrom<dynamic, dynamic>(json['Ancillaries']);
    calculation = List.from(json['Calculation'])
        .map((e) => Calculation.fromJson(e))
        .toList();
    totalPrice = TotalPrice.fromJson(json['TotalPrice']);
    Status = json['Status'];
    StatusPay = json['StatusPay'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['Date'] = Date;
    _data['DateUpdate'] = DateUpdate;
    _data['Stage'] = Stage;
    _data['RecordNumber'] = RecordNumber;
    _data['RecordPIN'] = RecordPIN;
    _data['RecordKey'] = RecordKey;
    _data['RecordDate'] = RecordDate;
    _data['RecordDateStamp'] = RecordDateStamp;
    _data['RecordPriceDate'] = RecordPriceDate;
    _data['RecordPriceDateStamp'] = RecordPriceDateStamp;
    _data['RecordExpireDate'] = RecordExpireDate;
    _data['RecordExpireDateStamp'] = RecordExpireDateStamp;
    _data['Locations'] = locations.map((e) => e.toJson()).toList();
    _data['Ancillaries'] = Ancillaries;
    _data['Calculation'] = calculation.map((e) => e.toJson()).toList();
    _data['TotalPrice'] = totalPrice.toJson();
    _data['Status'] = Status;
    _data['StatusPay'] = StatusPay;
    return _data;
  }
}

class Locations {
  Locations({
    this.ID,
    this.ExternalID,
    this.ExternalData,
    required this.Key,
    required this.Num,
    this.Date,
    this.DateTo,
    required this.Type,
    required this.Route,
    required this.RouteOrder,
    required this.point,
    required this.contact,
    this.Message,
    required this.Params,
    required this.Status,
  });
  late final Null ID;
  late final Null ExternalID;
  late final Null ExternalData;
  late final String Key;
  late final int Num;
  late final Null Date;
  late final Null DateTo;
  late final String Type;
  late final int Route;
  late final int RouteOrder;
  late final Point point;
  late final Contact contact;
  late final Null Message;
  late final List<dynamic> Params;
  late final String Status;

  Locations.fromJson(Map<String, dynamic> json) {
    ID = null;
    ExternalID = null;
    ExternalData = null;
    Key = json['Key'];
    Num = json['Num'];
    Date = null;
    DateTo = null;
    Type = json['Type'];
    Route = json['Route'];
    RouteOrder = json['RouteOrder'];
    point = Point.fromJson(json['Point']);
    contact = Contact.fromJson(json['Contact']);
    Message = null;
    Params = List.castFrom<dynamic, dynamic>(json['Params']);
    Status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['ExternalID'] = ExternalID;
    _data['ExternalData'] = ExternalData;
    _data['Key'] = Key;
    _data['Num'] = Num;
    _data['Date'] = Date;
    _data['DateTo'] = DateTo;
    _data['Type'] = Type;
    _data['Route'] = Route;
    _data['RouteOrder'] = RouteOrder;
    _data['Point'] = point.toJson();
    _data['Contact'] = contact.toJson();
    _data['Message'] = Message;
    _data['Params'] = Params;
    _data['Status'] = Status;
    return _data;
  }
}

class Point {
  Point({
    this.ID,
    required this.Address,
    required this.Source,
    required this.Code,
    required this.Latitude,
    required this.Longitude,
    this.Entrance,
    this.Floor,
    this.Room,
  });
  late final String? ID;
  late final String Address;
  late final String Source;
  late final String Code;
  late final double Latitude;
  late final double Longitude;
  late final Null Entrance;
  late final Null Floor;
  late final Null Room;

  Point.fromJson(Map<String, dynamic> json) {
    ID = null;
    Address = json['Address'];
    Source = json['Source'];
    Code = json['Code'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
    Entrance = null;
    Floor = null;
    Room = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['Address'] = Address;
    _data['Source'] = Source;
    _data['Code'] = Code;
    _data['Latitude'] = Latitude;
    _data['Longitude'] = Longitude;
    _data['Entrance'] = Entrance;
    _data['Floor'] = Floor;
    _data['Room'] = Room;
    return _data;
  }
}

class Contact {
  Contact({
    required this.Name,
    required this.Department,
    required this.PhoneMobile,
    required this.PhoneOffice,
    required this.PhoneOfficeAdd,
    required this.EmailPersonal,
    required this.EmailOffice,
  });
  late final String Name;
  late final String Department;
  late final String PhoneMobile;
  late final String PhoneOffice;
  late final String PhoneOfficeAdd;
  late final String EmailPersonal;
  late final String EmailOffice;

  Contact.fromJson(Map<String, dynamic> json) {
    Name = json['Name'];
    Department = json['Department'];
    PhoneMobile = json['PhoneMobile'];
    PhoneOffice = json['PhoneOffice'];
    PhoneOfficeAdd = json['PhoneOfficeAdd'];
    EmailPersonal = json['EmailPersonal'];
    EmailOffice = json['EmailOffice'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Name'] = Name;
    _data['Department'] = Department;
    _data['PhoneMobile'] = PhoneMobile;
    _data['PhoneOffice'] = PhoneOffice;
    _data['PhoneOfficeAdd'] = PhoneOfficeAdd;
    _data['EmailPersonal'] = EmailPersonal;
    _data['EmailOffice'] = EmailOffice;
    return _data;
  }
}

class Calculation {
  Calculation({
    required this.Key,
    required this.Value,
  });
  late final dynamic Key;
  late final dynamic Value;

  Calculation.fromJson(Map<String, dynamic> json) {
    Key = json['Key'];
    Value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Key'] = Key;
    _data['Value'] = Value;
    return _data;
  }
}

class TotalPrice {
  TotalPrice({
    required this.Base,
    required this.Ancillary,
    required this.Discount,
    required this.Compensation,
    required this.Bonus,
    required this.Tip,
    required this.Total,
    required this.Currency,
  });
  late final int Base;
  late final int Ancillary;
  late final int Discount;
  late final int Compensation;
  late final int Bonus;
  late final int Tip;
  late final int Total;
  late final String Currency;

  TotalPrice.fromJson(Map<String, dynamic> json) {
    Base = json['Base'];
    Ancillary = json['Ancillary'];
    Discount = json['Discount'];
    Compensation = json['Compensation'];
    Bonus = json['Bonus'];
    Tip = json['Tip'];
    Total = json['Total'];
    Currency = json['Currency'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Base'] = Base;
    _data['Ancillary'] = Ancillary;
    _data['Discount'] = Discount;
    _data['Compensation'] = Compensation;
    _data['Bonus'] = Bonus;
    _data['Tip'] = Tip;
    _data['Total'] = Total;
    _data['Currency'] = Currency;
    return _data;
  }
}
