part of 'deposit_bloc.dart';

abstract class DepositState {}

class CreateDepositStated extends DepositState {}

class CreateDeposit extends DepositState {}

class DepositLoading extends DepositState {}

class DepositLoad extends DepositState {
  List<Invoice>? list;

  DepositLoad(this.list);
}
