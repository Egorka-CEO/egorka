import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderPageBloc extends Bloc<NewOrderEvent, NewOrderState> {
  late GeoData data;
  NewOrderPageBloc() : super(NewOrderStated()) {
    on<NewOrder>((event, emit) => _searchAddress(event, emit));
    on<NewOrderOpenBtmSheet>((event, emit) => _openBtmSheet(event, emit));
    on<NewOrderStatedCloseBtmSheet>(
        (event, emit) => _closeBtmSheet(event, emit));
    on<NewOrderCloseBtmSheetEvent>(
        (event, emit) => _closeBtmSheetWithoutSearch(event, emit));
  }

  void _searchAddress(NewOrder event, Emitter<NewOrderState> emit) async {
    emit(NewOrderLoading());
    if (event.value.length < 2) {
      emit(NewOrderStated());
    } else {
      var result = await Repository().getAddress(event.value);
      if (result != null) {
        emit(NewOrderSuccess(result));
      } else {
        emit(NewOrderFailed());
      }
    }
  }

  void _openBtmSheet(NewOrderOpenBtmSheet event, Emitter<NewOrderState> emit) =>
      emit(NewOrderStatedOpenBtmSheet());

  void _closeBtmSheet(
          NewOrderStatedCloseBtmSheet event, Emitter<NewOrderState> emit) =>
      emit(NewOrderStateCloseBtmSheet(event.value));

  void _closeBtmSheetWithoutSearch(
          NewOrderCloseBtmSheetEvent event, Emitter<NewOrderState> emit) =>
      emit(NewOrderCloseBtmSheet());
}
