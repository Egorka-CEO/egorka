import 'package:egorka/model/address.dart';

class PointDetails {
  Suggestions suggestions;
  Details? details;

  PointDetails({required this.suggestions, this.details});
}

class Details {
  Suggestions? suggestions;
  String? entrance;
  String? floor;
  String? room;
  String? name;
  String? phone;
  String? comment;

  Details({
     this.suggestions,
    this.entrance,
    this.floor,
    this.room,
    this.name,
    this.phone,
    this.comment,
  });
}
