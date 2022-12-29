part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileStated extends ProfileState {}

class ProfileStatedUpdate extends ProfileState {}

class UpdateDeposit extends ProfileState {
  Accounts accounts;

  UpdateDeposit(this.accounts);
}

class ExitStated extends ProfileState {}
