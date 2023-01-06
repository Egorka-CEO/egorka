part of 'market_place_bloc.dart';

abstract class MarketPlaceEvent {}

class MarketPlaceOpenBtmSheet extends MarketPlaceEvent {}

class MarketPlaceCloseBtmSheetEvent extends MarketPlaceEvent {}

class MarketPlaceStatedCloseBtmSheet extends MarketPlaceEvent {
  Suggestions? address;

  MarketPlaceStatedCloseBtmSheet(this.address);
}

class MarketPlace extends MarketPlaceEvent {
  String value;

  MarketPlace(this.value);
}

class CalcOrderMarketplace extends MarketPlaceEvent {
  Suggestions? suggestion;
  DateTime? time;
  String group;
  PointMarketPlace? points;
  List<Ancillaries>? ancillaries;
  String? name;
  String? phone;
  int? bucket;
  int? pallet;

  String? entrance;
  String? floor;
  String? room;

  CalcOrderMarketplace(
    this.suggestion,
    this.points,
    this.ancillaries,
    this.time,
    this.group,
    this.name,
    this.phone,
    this.bucket,
    this.pallet,
  );
}

class GetMarketPlaces extends MarketPlaceEvent {}

class CreateForm extends MarketPlaceEvent {
  String id;

  CreateForm(this.id);
}

class SelectMarketPlaces extends MarketPlaceEvent {
  PointMarketPlace points;

  SelectMarketPlaces(this.points);
}

class MarketUpdateState extends MarketPlaceEvent {}
