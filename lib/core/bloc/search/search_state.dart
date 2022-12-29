part of 'search_bloc.dart';

abstract class SearchAddressState {}

class SearchLoading extends SearchAddressState {}

class SearchAddressStated extends SearchAddressState {}

class SearchAddressRoutePolilyne extends SearchAddressState {
  Directions routes;
  Set<Marker> markers;
  List<CoastResponse> coasts;

  SearchAddressRoutePolilyne(this.routes, this.markers, this.coasts);
}

class DeletePolilyneState extends SearchAddressState {}

class SearchAddressLoading extends SearchAddressState {}

class SearchAddressSuccess extends SearchAddressState {
  Address? address;

  SearchAddressSuccess(this.address);
}

class ChangeAddressSuccess extends SearchAddressState {
  String address;
  double latitude;
  double longitude;

  ChangeAddressSuccess(
    this.address,
    this.latitude,
    this.longitude,
  );
}

class GetAddressSuccess extends SearchAddressState {
  String address;
  double latitude;
  double longitude;

  GetAddressSuccess(
    this.address,
    this.latitude,
    this.longitude,
  );
}

class SearchAddressFailed extends SearchAddressState {}

class FindMeState extends SearchAddressState {}

class JumpToPointState extends SearchAddressState {
  final Point point;

  JumpToPointState(this.point);
}
