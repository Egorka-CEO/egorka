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
  List<DrivingSessionResult> routes;
  List<BicycleSessionResult> bicycleSessionResult;
  PlacemarkIcon startMarker;
  PlacemarkIcon endMarker;

  HistoryOrderRoutePolilyne(
    this.routes,
    this.bicycleSessionResult,
    this.startMarker,
    this.endMarker,
  );
}
