import 'package:egorka/model/suggestions.dart';

class Address {
  String time;
  int timeStamp;
  double execution;
  String method;
  Result result;
  List<Errors>? errors;

  Address({
    required this.time,
    required this.timeStamp,
    required this.execution,
    required this.method,
    required this.result,
    required this.errors,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    final time = json['Time'];
    final timeStamp = json['TimeStamp'];
    final execution = json['Execution'];
    final method = json['Method'];
    final result =
        json['Result'] != null ? Result.fromJson(json['Result']) : null;
    List<Errors>? errors;
    if (json['Errors'] != null) {
      errors = [];
      json['Errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    return Address(
      time: time,
      timeStamp: timeStamp,
      execution: execution,
      method: method,
      result: result!,
      errors: errors,
    );
  }
}

class Result {
  bool cached;
  List<Suggestions>? suggestions;

  Result({
    required this.cached,
    required this.suggestions,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    final cached = json['Cached'];
    List<Suggestions>? suggestions;
    if (json['Suggestions'] != null) {
      suggestions = [];
      json['Suggestions'].forEach((v) {
        if (v['ID'] != null) {
          suggestions!.add(Suggestions.fromJson(v));
        }
      });
    }
    return Result(
      cached: cached,
      suggestions: suggestions,
    );
  }
}

class Errors {
  String? type;
  int? code;
  String? message;
  String? description;
  String? messagePrepend;

  Errors({
    required this.type,
    required this.code,
    required this.message,
    required this.description,
    required this.messagePrepend,
  });

  factory Errors.fromJson(Map<String, dynamic> json) {
    final type = json['Type'];
    final code = json['Code'];
    final message = json['Message'];
    final description = json['Description'];
    final messagePrepend = json['MessagePrepend'];
    return Errors(
      type: type,
      code: code,
      message: message,
      description: description,
      messagePrepend: messagePrepend,
    );
  }
}
