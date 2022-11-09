import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;

part 'market_place_event.dart';
part 'market_place_state.dart';

class MarketPlacePageBloc extends Bloc<MarketPlaceEvent, MarketPlaceState> {
  late GeoData data;
  mrkt.MarketPlaces? marketPlaces;

  MarketPlacePageBloc() : super(MarketPlaceStated()) {
    on<MarketPlace>(_searchAddress);
    on<MarketPlaceOpenBtmSheet>(_openBtmSheet);
    on<MarketPlaceStatedCloseBtmSheet>(_closeBtmSheet);
    on<MarketPlaceCloseBtmSheetEvent>(_closeBtmSheetWithoutSearch);
    on<GetMarketPlaces>(_getMarketPlaces);
    on<SelectMarketPlaces>(_selectMarketPlaces);
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

  void _getMarketPlaces(
      GetMarketPlaces event, Emitter<MarketPlaceState> emit) async {
    var result = await Repository().getMarketplaces();
    if (result != null) {
      marketPlaces = result;
      emit(MarketPlacesSuccessState());
    }
  }

  void _selectMarketPlaces(
      SelectMarketPlaces event, Emitter<MarketPlaceState> emit) async {

      emit(MarketPlacesSelectPointState(event.points));
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
