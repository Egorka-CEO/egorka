part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInit extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  final AuthUser _user;

  ProfileEventUpdate(this._user);
}

class GetDepositEvent extends ProfileEvent {}

class ExitAccountEvent extends ProfileEvent {}
