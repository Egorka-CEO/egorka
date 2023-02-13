import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/account_deposit.dart';
import 'package:egorka/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AuthUser? _user;
  AccountsDeposit? deposit;
  ProfileBloc() : super(ProfileStated()) {
    on<ProfileEventInit>(_init);
    on<ProfileEventUpdate>(_updateUser);
    on<GetDepositeEvent>(_getDeposite);
    on<ExitAccountEvent>(_exitAccount);
  }

  void _init(ProfileEventInit event, Emitter<ProfileState> emit) async {}

  void _updateUser(ProfileEventUpdate event, Emitter<ProfileState> emit) {
    _user = event._user;
    emit(ProfileStatedUpdate());
  }

  void _exitAccount(ExitAccountEvent event, Emitter<ProfileState> emit) {
    _user = null;
    MySecureStorage storage = MySecureStorage();
    storage.setTypeUser(null);
    storage.setLogin(null);
    storage.setPassword(null);
    storage.setCompany(null);
    storage.setID(null);
    storage.setKey(null);
    storage.setTypeAuth(null);
    storage.setSecure(null);
    // storage.se(null);
    emit(ExitStated());
  }

  void _getDeposite(GetDepositeEvent event, Emitter<ProfileState> emit) async {
    final accounts = await Repository().getDeposit();
    if (accounts != null) {
      deposit = accounts;
      emit(UpdateDeposit(accounts.result!.accounts[0]));
    }
  }

  AuthUser? getUser() => _user;
}
