part of 'search_bloc.dart';

abstract class SearchAddressEvent {}

class SearchAddress extends SearchAddressEvent {
  String value;

  SearchAddress(this.value);
}

class ChangeMapPosition extends SearchAddressEvent {
  LatLng coordinates;

  ChangeMapPosition(this.coordinates);
}

class SearchAddressClear extends SearchAddressEvent {}
