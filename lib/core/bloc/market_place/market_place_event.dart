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

class CalcOrder extends MarketPlaceEvent {
  Suggestions? suggestion;
  DateTime? time;
  mrkt.Points? points;
  String? name;
  String? phone;
  int? bucket;
  int? pallet;

  String? entrance;
  String? floor;
  String? room;

  CalcOrder(
    this.suggestion,
    this.points,
    this.time,
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
  mrkt.Points points;

  SelectMarketPlaces(this.points);
}
