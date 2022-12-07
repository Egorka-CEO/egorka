part of 'market_place_bloc.dart';

abstract class MarketPlaceState {}

class MarketPlaceStated extends MarketPlaceState {}

class MarketPlaceStatedOpenBtmSheet extends MarketPlaceState {}

class MarketPlaceCloseBtmSheet extends MarketPlaceState {}

class MarketPlaceStateCloseBtmSheet extends MarketPlaceState {
  Suggestions? address;

  MarketPlaceStateCloseBtmSheet(this.address);
}

class MarketPlaceLoading extends MarketPlaceState {}

class MarketPlaceSuccess extends MarketPlaceState {
  Address? address;

  MarketPlaceSuccess(this.address);
}

class MarketPlaceFailed extends MarketPlaceState {}

class MarketPlacesSuccessState extends MarketPlaceState {
  CoastResponse? coastResponse;

  MarketPlacesSuccessState(this.coastResponse);
}

class MarketPlacesSelectPointState extends MarketPlaceState {
  mrkt.Points points;

  MarketPlacesSelectPointState(this.points);
}
