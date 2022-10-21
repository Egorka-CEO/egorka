part of 'search_bloc.dart';

abstract class SearchAddressState {}

class SearchAddressStated extends SearchAddressState {}

class SearchAddressRoutePolilyne extends SearchAddressState {
  Directions routes;
  Set<Marker> markers;

  SearchAddressRoutePolilyne(this.routes, this.markers);
}

class DeletePolilyneState extends SearchAddressState {}

class SearchAddressLoading extends SearchAddressState {}

class SearchAddressSuccess extends SearchAddressState {
  Address? address;

  SearchAddressSuccess(this.address);
}

class ChangeAddressSuccess extends SearchAddressState {
  GeoData? geoData;

  ChangeAddressSuccess(this.geoData);
}

class SearchAddressFailed extends SearchAddressState {}

class FindMeState extends SearchAddressState {}

class JumpToPointState extends SearchAddressState {
  final Point point;

  JumpToPointState(this.point);
}
