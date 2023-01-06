part of 'new_order_bloc.dart';

abstract class NewOrderEvent {}

class NewOrderOpenBtmSheet extends NewOrderEvent {}

class NewOrderUpdateState extends NewOrderEvent {}

class NewOrderCloseBtmSheetEvent extends NewOrderEvent {}

class NewOrderStatedCloseBtmSheet extends NewOrderEvent {
  Suggestions? value;

  NewOrderStatedCloseBtmSheet(this.value);
}

class NewOrder extends NewOrderEvent {
  String value;

  NewOrder(this.value);
}

class CalculateCoastEvent extends NewOrderEvent {
  List<PointDetails> start;
  List<PointDetails> end;
  String typeCoast;
  List<Ancillaries>? ancillaries;
  String description;

  CalculateCoastEvent(
    this.start,
    this.end,
    this.typeCoast,
    this.ancillaries,
    this.description,
  );
}

class CreateForm extends NewOrderEvent {
  String id;

  CreateForm(this.id);
}
