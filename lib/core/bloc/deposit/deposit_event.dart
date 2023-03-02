part of 'deposit_bloc.dart';

abstract class DepositEvent {}

class CreateDeposotEvent extends DepositEvent {
  Invoice invoice;

  CreateDeposotEvent(this.invoice);
}

class LoadReplenishmentDepositEvent extends DepositEvent {
  Filter filter;
  int page;

  LoadReplenishmentDepositEvent(this.filter, this.page);
}
