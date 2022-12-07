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
  mrkt.Points? points;

  CalcOrder(this.suggestion, this.points);
}

class GetMarketPlaces extends MarketPlaceEvent {}

class SelectMarketPlaces extends MarketPlaceEvent {
  mrkt.Points points;

  SelectMarketPlaces(this.points);
}
