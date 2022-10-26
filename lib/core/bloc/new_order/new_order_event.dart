part of 'new_order_bloc.dart';

abstract class NewOrderEvent {}

class NewOrderOpenBtmSheet extends NewOrderEvent {}

class NewOrderCloseBtmSheetEvent extends NewOrderEvent {}

class NewOrderStatedCloseBtmSheet extends NewOrderEvent {
  String? value;

  NewOrderStatedCloseBtmSheet(this.value);
}

class NewOrder extends NewOrderEvent {
  String value;

  NewOrder(this.value);
}
