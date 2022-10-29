part of 'history_orders_bloc.dart';

abstract class HistoryOrdersEvent {}

class HistoryOrders extends HistoryOrdersEvent {}

class OpenBtmSheetHistoryEvent extends HistoryOrdersEvent {}

class CloseBtmSheetHistoryEvent extends HistoryOrdersEvent {}
