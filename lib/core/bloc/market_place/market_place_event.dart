part of 'market_place_bloc.dart';

abstract class MarketPlaceEvent {}

class MarketPlaceOpenBtmSheet extends MarketPlaceEvent {}

class MarketPlaceCloseBtmSheetEvent extends MarketPlaceEvent {}

class MarketPlaceStatedCloseBtmSheet extends MarketPlaceEvent {
  String? value;

  MarketPlaceStatedCloseBtmSheet(this.value);
}

class MarketPlace extends MarketPlaceEvent {
  String value;

  MarketPlace(this.value);
}
