part of 'search_bloc.dart';

abstract class SearchAddressState {}

class SearchLoading extends SearchAddressState {}

class SearchAddressStated extends SearchAddressState {}

class SearchAddressRoutePolilyne extends SearchAddressState {
  DrivingSessionResult? directions;
  BicycleSessionResult? directionsBicycle;
  List<PlacemarkMapObject> markers;
  List<CoastResponse> coasts;

  SearchAddressRoutePolilyne(
    this.directions,
    this.directionsBicycle,
    this.markers,
    this.coasts,
  );
}

class EditPolilynesState extends SearchAddressState {
  DrivingSessionResult? directionsDrive;
  BicycleSessionResult? directionsBicycle;
  List<PlacemarkMapObject> markers;

  EditPolilynesState({
    this.directionsDrive,
    this.directionsBicycle,
    this.markers = const [],
  });
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
  String? errorAddress;

  ChangeAddressSuccess(
    this.address,
    this.latitude,
    this.longitude,
    this.errorAddress,
  );
}

class GetAddressSuccess extends SearchAddressState {
  String address;
  double latitude;
  double longitude;
  String? errorAddress;

  GetAddressSuccess(
    this.address,
    this.latitude,
    this.longitude,
    this.errorAddress,
  );
}

class SearchAddressFailed extends SearchAddressState {}

class FindMeState extends SearchAddressState {}

class JumpToPointState extends SearchAddressState {
  final point_model.Point point;

  JumpToPointState(this.point);
}
