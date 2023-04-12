part of 'search_bloc.dart';

abstract class SearchAddressEvent {}

class SearchAddress extends SearchAddressEvent {
  String value;

  SearchAddress(this.value);
}

class MarketPlaceCalcEvent extends SearchAddressEvent {
  bool loadingAnimation;
  CoastMarketPlace coast;

  List<Suggestions?> suggestionsStart;
  List<Suggestions?> suggestionsEnd;

  MarketPlaceCalcEvent(
    this.loadingAnimation,
    this.coast,
    this.suggestionsStart,
    this.suggestionsEnd,
  );
}

class ChangeMapPosition extends SearchAddressEvent {
  double lat;
  double lon;

  ChangeMapPosition(this.lat, this.lon);
}

class GetAddressPosition extends SearchAddressEvent {}

class EditPolilynesEvent extends SearchAddressEvent {
  DrivingSessionResult? directions;
  BicycleSessionResult? directionsBicycle;
  List<PlacemarkMapObject> markers;

  EditPolilynesEvent(
      {this.directions, this.directionsBicycle, this.markers = const []});
}

class SearchAddressClear extends SearchAddressEvent {}

class SearchMeEvent extends SearchAddressEvent {}

class JumpToPointEvent extends SearchAddressEvent {
  final pointModel.Point point;

  JumpToPointEvent(this.point);
}

class SearchAddressPolilyne extends SearchAddressEvent {
  List<Suggestions?> suggestionsStart;
  List<Suggestions?> suggestionsEnd;

  SearchAddressPolilyne(
    this.suggestionsStart,
    this.suggestionsEnd,
  );
}

class DeletePolilyneEvent extends SearchAddressEvent {}

class GetMarketPlaces extends SearchAddressEvent {}
