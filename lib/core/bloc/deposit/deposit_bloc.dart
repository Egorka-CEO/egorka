import 'dart:math';

import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/invoice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(CreateDepositStated()) {
    on<LoadReplenishmentDepositEvent>(_loadReplenishmentDeposit);
  }

  void _loadReplenishmentDeposit(
      LoadReplenishmentDepositEvent event, Emitter<DepositState> emit) async {
    emit(DepositLoading());
    List<Invoice>? list = await Repository().getInvoiceFilter(event.filter);
    emit(DepositLoad(list, event.page));
  }
}
