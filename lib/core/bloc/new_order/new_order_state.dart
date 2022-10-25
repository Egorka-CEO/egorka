part of 'new_order_bloc.dart';

abstract class NewOrderState {}

class NewOrderStated extends NewOrderState {}

class NewOrderStatedOpenBtmSheet extends NewOrderState {}

class NewOrderStateCloseBtmSheet extends NewOrderState {
  String value;

  NewOrderStateCloseBtmSheet(this.value);
}

class NewOrderLoading extends NewOrderState {}

class NewOrderSuccess extends NewOrderState {
  Address? address;

  NewOrderSuccess(this.address);
}

class NewOrderFailed extends NewOrderState {}
