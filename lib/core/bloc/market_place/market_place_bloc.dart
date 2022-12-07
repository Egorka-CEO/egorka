import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart' as adv;
import 'package:egorka/model/response_coast_base.dart';
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
    on<CalcOrder>(_calculateOrder);
  }

  void _calculateOrder(CalcOrder event, Emitter<MarketPlaceState> emit) async {
    var result = await Repository().getCoastAdvanced(
      adv.CoastAdvanced(
        iD: null,
        type: 'Walk',
        locations: [
          adv.Locations(
            type: 'Pickup',
            point: adv.Point(
              code: event.suggestion!.iD,
            ),
          ),
          adv.Locations(
            type: 'Drop',
            point: adv.Point(
              code: event.points!.code,
            ),
          )
        ],
      ),
    );
    // if (result != null) {
      emit(MarketPlacesSuccessState(result));
    // }
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
      emit(MarketPlacesSuccessState(null));
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
      Emitter<MarketPlaceState> emit) async {
    emit(MarketPlaceStateCloseBtmSheet(event.address));
  }

  void _closeBtmSheetWithoutSearch(MarketPlaceCloseBtmSheetEvent event,
          Emitter<MarketPlaceState> emit) =>
      emit(MarketPlaceCloseBtmSheet());
}
