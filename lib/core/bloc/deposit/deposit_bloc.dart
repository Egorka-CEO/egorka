import 'package:egorka/model/invoice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  InvoiceModel? invoiceModel;

  DepositBloc() : super(CreateDepositStated()) {
    on<CreateDeposotEvent>(_createDeposit);
  }

  void _createDeposit(CreateDeposotEvent event, Emitter<DepositState> emit) {
    invoiceModel = event.invoice;
  }
}
