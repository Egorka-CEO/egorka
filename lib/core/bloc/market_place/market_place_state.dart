part of 'market_place_bloc.dart';

abstract class MarketPlaceState {}

class MarketPlaceStated extends MarketPlaceState {}

class MarketPlaceStatedOpenBtmSheet extends MarketPlaceState {}

class MarketPlaceCloseBtmSheet extends MarketPlaceState {}

class MarketPlaceStateCloseBtmSheet extends MarketPlaceState {
  String? value;

  MarketPlaceStateCloseBtmSheet(this.value);
}

class MarketPlaceLoading extends MarketPlaceState {}

class MarketPlaceSuccess extends MarketPlaceState {
  Address? address;

  MarketPlaceSuccess(this.address);
}

class MarketPlaceFailed extends MarketPlaceState {}
