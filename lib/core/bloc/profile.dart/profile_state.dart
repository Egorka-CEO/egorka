part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileStated extends ProfileState {}

class ProfileStatedUpdate extends ProfileState {
  AuthUser user;

  ProfileStatedUpdate(this.user);
}

class UpdateDeposit extends ProfileState {
  Accounts accounts;

  UpdateDeposit(this.accounts);
}
