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

class SearchMeEvent extends SearchAddressEvent {}

class JumpToPointEvent extends SearchAddressEvent {
  final Point point;
  JumpToPointEvent(this.point);
}

class SearchAddressPolilyne extends SearchAddressEvent {
  String from;
  String to;

  SearchAddressPolilyne(this.from, this.to);
}

class DeletePolilyneEvent extends SearchAddressEvent {}
