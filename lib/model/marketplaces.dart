import 'package:egorka/model/point_marketplace.dart';

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

  MarketPlaces.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    timeStamp = json['TimeStamp'];
    execution = json['Execution'];
    method = json['Method'];
    result = Result.fromJson(json['Result']);
  }
}

class Result {
  Result({
    required this.cached,
    required this.points,
  });
  late final bool cached;
  List<PointMarketPlace> points = [];

  Result.fromJson(Map<String, dynamic> json) {
    cached = json['Cached'];
    for (var element in json['Points']) {
      points.add(PointMarketPlace.fromJson(element));
    }
  }
}

class Name {
  Name({
    required this.name,
    required this.language,
  });
  late final String name;
  late final String language;

  Name.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    language = json['Language'];
  }
}
