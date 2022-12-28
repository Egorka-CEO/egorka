part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileEventInit extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  AuthUser _user;

  ProfileEventUpdate(this._user);
}

class GetDepositeEvent extends ProfileEvent {}

class ExitAccountEvent extends ProfileEvent {}
