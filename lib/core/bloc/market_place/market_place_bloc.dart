import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';

part 'market_place_event.dart';
part 'market_place_state.dart';

class MarketPlacePageBloc extends Bloc<MarketPlaceEvent, MarketPlaceState> {
  late GeoData data;
  MarketPlacePageBloc() : super(MarketPlaceStated()) {
    on<MarketPlace>((event, emit) => _searchAddress(event, emit));
    on<MarketPlaceOpenBtmSheet>((event, emit) => _openBtmSheet(event, emit));
    on<MarketPlaceStatedCloseBtmSheet>(
        (event, emit) => _closeBtmSheet(event, emit));
    on<MarketPlaceCloseBtmSheetEvent>(
        (event, emit) => _closeBtmSheetWithoutSearch(event, emit));
  }

  void _searchAddress(MarketPlace event, Emitter<MarketPlaceState> emit) async {
    emit(MarketPlaceLoading());
    if (event.value.length < 2) {
      emit(MarketPlaceStated());
    } else {
      var result = await Repository().getAddress(event.value);
      if (result != null) {
        emit(MarketPlaceSuccess(result));
      } else {
        emit(MarketPlaceFailed());
      }
    }
  }

  void _openBtmSheet(
          MarketPlaceOpenBtmSheet event, Emitter<MarketPlaceState> emit) =>
      emit(MarketPlaceStatedOpenBtmSheet());

  void _closeBtmSheet(MarketPlaceStatedCloseBtmSheet event,
          Emitter<MarketPlaceState> emit) =>
      emit(MarketPlaceStateCloseBtmSheet(event.value));

  void _closeBtmSheetWithoutSearch(MarketPlaceCloseBtmSheetEvent event,
          Emitter<MarketPlaceState> emit) =>
      emit(MarketPlaceCloseBtmSheet());
}
