import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/invoice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  List<Invoice> invoiceModel = [];

  DepositBloc() : super(CreateDepositStated()) {
    on<CreateDeposotEvent>(_createDeposit);
    on<LoadAllDepositEvent>(_loadAllDeposit);
  }

  void _createDeposit(CreateDeposotEvent event, Emitter<DepositState> emit) {
    invoiceModel.add(event.invoice);
  }

  void _loadAllDeposit(LoadAllDepositEvent event, Emitter<DepositState> emit) async {
    List<Invoice>? list = await Repository().getAllInvoice();
    if(list!=null) invoiceModel.addAll(list);
  }
}
