part of 'history_orders_bloc.dart';

abstract class HistoryOrdersState {}

class HistoryOrdesrStated extends HistoryOrdersState {}

class HistoryOpenBtmSheetState extends HistoryOrdersState {}

class HistoryCloseBtmSheetState extends HistoryOrdersState {}

class HistoryUpdateList extends HistoryOrdersState {
  List<CreateFormModel> coast;

  HistoryUpdateList(this.coast);
}

class HistoryOrderRoutePolilyne extends HistoryOrdersState {
  Directions routes;
  Set<Marker> markers;

  HistoryOrderRoutePolilyne(this.routes, this.markers);
}
