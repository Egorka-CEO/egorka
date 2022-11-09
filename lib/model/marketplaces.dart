class MarketPlaces {
  MarketPlaces({
    required this.time,
    required this.timeStamp,
    required this.execution,
    required this.method,
    required this.result,
  });
  late final String time;
  late final int timeStamp;
  late final double execution;
  late final String method;
  late final Result result;
  
  MarketPlaces.fromJson(Map<String, dynamic> json){
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = Result.fromJson(json['Result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Time'] = time;
    _data['TimeStamp'] = timeStamp;
    _data['Execution'] = execution;
    _data['Method'] = method;
    _data['Result'] = result.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.cached,
    required this.points,
  });
  late final bool cached;
  late final List<Points> points;
  
  Result.fromJson(Map<String, dynamic> json){
    cached = json['Cached'];
    points = List.from(json['Points']).map((e)=>Points.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Cached'] = cached;
    _data['Points'] = points.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Points {
  Points({
    required this.ID,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });
  late final String ID;
  late final String code;
  late final double latitude;
  late final double longitude;
  late final List<Name> name;
  late final List<Address> address;
  
  Points.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    code = json['Code'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    name = List.from(json['Name']).map((e)=>Name.fromJson(e)).toList();
    address = List.from(json['Address']).map((e)=>Address.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['Code'] = code;
    _data['Latitude'] = latitude;
    _data['Longitude'] = longitude;
    _data['Name'] = name.map((e)=>e.toJson()).toList();
    _data['Address'] = address.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Name {
  Name({
    required this.name,
    required this.language,
  });
  late final String name;
  late final String language;
  
  Name.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    language = json['Language'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Name'] = name;
    _data['Language'] = language;
    return _data;
  }
}

class Address {
  Address({
    required this.address,
    required this.language,
  });
  late final String address;
  late final String language;
  
  Address.fromJson(Map<String, dynamic> json){
    address = json['Address'];
    language = json['Language'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Address'] = address;
    _data['Language'] = language;
    return _data;
  }
}