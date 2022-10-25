part of 'current_order_bloc.dart';

abstract class CurrentOrderState {}

class CurrentOrderStated extends CurrentOrderState {}

class CurrentOrderRoutePolilyne extends CurrentOrderState {
  Directions routes;
  Set<Marker> markers;

  CurrentOrderRoutePolilyne(this.routes, this.markers);
}

class DeletePolilyneState extends CurrentOrderState {}

class CurrentOrderLoading extends CurrentOrderState {}

class CurrentOrderSuccess extends CurrentOrderState {
  Address? address;

  CurrentOrderSuccess(this.address);
}

class ChangeCurrentOrderSuccess extends CurrentOrderState {
  GeoData? geoData;

  ChangeCurrentOrderSuccess(this.geoData);
}

class CurrentOrderFailed extends CurrentOrderState {}

class FindMeState extends CurrentOrderState {}

class JumpToPointState extends CurrentOrderState {
  final Point point;

  JumpToPointState(this.point);
}
