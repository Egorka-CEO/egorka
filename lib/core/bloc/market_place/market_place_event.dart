part of 'market_place_bloc.dart';

abstract class MarketPlaceEvent {}

class MarketPlaceOpenBtmSheet extends MarketPlaceEvent {}

class MixFbsCalcEvent extends MarketPlaceEvent {
  bool loadingAnimation;

  CoastMarketPlace coast;

  MixFbsCalcEvent(
    this.loadingAnimation,
    this.coast,
  );
}

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
  bool loadingAnimation;
  String? id;
  Suggestions? suggestionStart;
  DateTime? time;
  String group;
  Suggestions? suggestionsEnd;
  List<Ancillaries>? ancillaries;
  String? name;
  String? phone;
  List<Cargos>? cargos;

  String? entrance;
  String? floor;
  String? room;

  CalcOrderMarketplace(
    this.loadingAnimation,
    this.id,
    this.suggestionStart,
    this.suggestionsEnd,
    this.ancillaries,
    this.time,
    this.group,
    this.name,
    this.phone,
    this.cargos,
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
