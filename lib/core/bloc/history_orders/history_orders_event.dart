part of 'history_orders_bloc.dart';

abstract class HistoryOrdersEvent {}

class HistoryOrders extends HistoryOrdersEvent {}

class OpenBtmSheetHistoryEvent extends HistoryOrdersEvent {}

class CloseBtmSheetHistoryEvent extends HistoryOrdersEvent {}

class HistoryUpdateListEvent extends HistoryOrdersEvent {
  CreateFormModel coast;

  HistoryUpdateListEvent(this.coast);
}

class HistoryOrderPolilyne extends HistoryOrdersEvent {
  List<Locations> locations;

  HistoryOrderPolilyne(this.locations);
}

class GetListOrdersEvent extends HistoryOrdersEvent {}
