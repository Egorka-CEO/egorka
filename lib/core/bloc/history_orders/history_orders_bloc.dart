import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_orders_event.dart';
part 'history_orders_state.dart';

class HistoryOrdersBloc extends Bloc<HistoryOrdersEvent, HistoryOrdersState> {
  HistoryOrdersBloc() : super(HistoryOrdesrStated()) {
    on<OpenBtmSheetHistoryEvent>((event, emit) => _openBtmSheet(event, emit));
    on<CloseBtmSheetHistoryEvent>((event, emit) => _closeBtmSheet(event, emit));
  }

  void _openBtmSheet(
          OpenBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryOpenBtmSheetState());

  void _closeBtmSheet(
          CloseBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryCloseBtmSheetState());
}
