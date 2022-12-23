part of 'deposit_bloc.dart';

abstract class DepositEvent {}

class CreateDeposotEvent extends DepositEvent {
  InvoiceModel invoice;

  CreateDeposotEvent(this.invoice);
}
