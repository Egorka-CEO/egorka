part of 'current_order_bloc.dart';

abstract class CurrentOrderEvent {}

class CurrentOrder extends CurrentOrderEvent {
  String value;

  CurrentOrder(this.value);
}

class ChangeMapPosition extends CurrentOrderEvent {
  LatLng coordinates;

  ChangeMapPosition(this.coordinates);
}

class CurrentOrderClear extends CurrentOrderEvent {}

class SearchMeEvent extends CurrentOrderEvent {}

class JumpToPointEvent extends CurrentOrderEvent {
  final Point point;
  JumpToPointEvent(this.point);
}

class CurrentOrderPolilyne extends CurrentOrderEvent {
  String from;
  String to;

  CurrentOrderPolilyne(this.from, this.to);
}

class DeletePolilyneEvent extends CurrentOrderEvent {}
