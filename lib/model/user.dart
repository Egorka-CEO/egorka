import 'package:egorka/model/agent.dart';

class AuthUser {
  String? time;
  int? timeStamp;
  double? execution;
  String? method;
  Result? result;
  List<Errors>? errors;

  AuthUser(
      {this.time,
      this.timeStamp,
      this.execution,
      this.method,
      this.result,
      this.errors});

  AuthUser.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
    List<Errors>? errors;
    if (json['Errors'] != null) {
      errors = [];
      json['Errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Time'] = time;
    data['TimeStamp'] = timeStamp;
    data['Execution'] = execution;
    data['Method'] = method;
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    data['Errors'] = errors;
    return data;
  }
}

class Result {
  String? date;
  int? dateStamp;
  String? dateUpdate;
  int? dateUpdateStamp;
  String? dateExpire;
  int? dateExpireStamp;
  String? key;
  String? secure;
  Agent? agent;
  User? user;

  Result(
      {this.date,
      this.dateStamp,
      this.dateUpdate,
      this.dateUpdateStamp,
      this.dateExpire,
      this.dateExpireStamp,
      this.key,
      this.secure,
      this.agent,
      this.user});

  Result.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    dateStamp = json['DateStamp'];
    dateUpdate = json['DateUpdate'];
    dateUpdateStamp = json['DateUpdateStamp'];
    dateExpire = json['DateExpire'];
    dateExpireStamp = json['DateExpireStamp'];
    key = json['Key'];
    secure = json['Secure'];
    agent = json['Agent'] != null ? Agent.fromJson(json['Agent']) : null;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    data['DateStamp'] = dateStamp;
    data['DateUpdate'] = dateUpdate;
    data['DateUpdateStamp'] = dateUpdateStamp;
    data['DateExpire'] = dateExpire;
    data['DateExpireStamp'] = dateExpireStamp;
    data['Key'] = key;
    data['Secure'] = secure;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? surname;
  String? patronymic;
  String? username;
  String? email;
  String? phoneOffice;
  String? phoneMobile;
  String? timeZone;
  String? language;

  User(
      {this.name,
      this.surname,
      this.patronymic,
      this.username,
      this.email,
      this.phoneOffice,
      this.phoneMobile,
      this.timeZone,
      this.language});

  User.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    surname = json['Surname'];
    patronymic = json['Patronymic'];
    username = json['Username'];
    email = json['Email'];
    phoneOffice = json['PhoneOffice'];
    phoneMobile = json['PhoneMobile'];
    timeZone = json['TimeZone'];
    language = json['Language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Surname'] = surname;
    data['Patronymic'] = patronymic;
    data['Username'] = username;
    data['Email'] = email;
    data['PhoneOffice'] = phoneOffice;
    data['PhoneMobile'] = phoneMobile;
    data['TimeZone'] = timeZone;
    data['Language'] = language;
    return data;
  }
}

class Errors {
  String type;
  int code;
  String message;
  String description;

  Errors(
      {required this.type,
      required this.code,
      required this.message,
      required this.description});

  factory Errors.fromJson(Map<String, dynamic> json) {
    final type = json['Type'];
    final code = json['Code'];
    final message = json['Message'];
    final description = json['Description'];
    return Errors(
      type: type,
      code: code,
      message: message,
      description: description,
    );
  }
}
