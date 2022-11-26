class UUIDCreate {
  String? time;
  int? timeStamp;
  double? execution;
  String? method;
  Result? result;
  Errors? errors;

  UUIDCreate({
    this.time,
    this.timeStamp,
    this.execution,
    this.method,
    this.result,
    this.errors,
  });

  UUIDCreate.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
    errors = json['Errors'];
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
  String? iD;
  String? secure;
  String? status;

  Result({
    this.iD,
    this.secure,
    this.status,
  });

  Result.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    secure = json['Secure'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Secure'] = secure;
    data['Status'] = status;
    return data;
  }
}

class Errors {
  List<Errors>? errors;

  Errors({
    this.errors,
  });

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['Errors'] != null) {
      errors = <Errors>[];
      json['Errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errors != null) {
      data['Errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
