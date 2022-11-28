import 'package:egorka/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AuthUser? _user;
  ProfileBloc() : super(ProfileStated()) {
    on<ProfileEventInit>(_init);
    on<ProfileEventUpdate>(_updateUser);
  }

  void _init(ProfileEventInit event, Emitter<ProfileState> emit) async {}

  void _updateUser(ProfileEventUpdate event, Emitter<ProfileState> emit) {
    _user = event._user;
    emit(ProfileStatedUpdate(_user!));
  }

  AuthUser? getUser() => _user;
}
