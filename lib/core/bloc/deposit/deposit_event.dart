part of 'deposit_bloc.dart';

abstract class DepositEvent {}

class CreateDeposotEvent extends DepositEvent {
  Invoice invoice;

  CreateDeposotEvent(this.invoice);
}

class LoadAllDepositEvent extends DepositEvent {}
