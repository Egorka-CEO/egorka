import 'dart:developer';

import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/cargos.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/contact.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/model/point_marketplace.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
part 'market_place_event.dart';
part 'market_place_state.dart';

class MarketPlacePageBloc extends Bloc<MarketPlaceEvent, MarketPlaceState> {
  MarketPlaces? marketPlaces;

  MarketPlacePageBloc() : super(MarketPlaceStated()) {
    on<MarketPlace>(_searchAddress);
    on<MixFbsCalcEvent>(_calculateOrderMixFbs);
    on<MarketPlaceOpenBtmSheet>(_openBtmSheet);
    on<MarketPlaceStatedCloseBtmSheet>(_closeBtmSheet);
    on<MarketPlaceCloseBtmSheetEvent>(_closeBtmSheetWithoutSearch);
    on<GetMarketPlaces>(_getMarketPlaces);
    on<SelectMarketPlaces>(_selectMarketPlaces);
    on<CalcOrderMarketplace>(_calculateOrderMarketplace);
    on<CreateForm>(_createForm);
    on<MarketUpdateState>(_updateState);
  }

  void _calculateOrderMixFbs(
      MixFbsCalcEvent event, Emitter<MarketPlaceState> emit) async {
    if (event.loadingAnimation) emit(CalcLoading());
    var result = await Repository().getCoastMarketPlace(
      CoastMarketPlace(
        iD: event.id,
        type: "Truck",
        group: event.group,
        locations: [
          Location(
            id: '',
            date: event.time != null
                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(event.time!)
                : null,
            point: Point(
              id: 'EGORKA_SC',
              code: '',
              entrance: '',
              floor: '',
              room: '',
            ),
            contact: Contact(name: event.name, phoneMobile: event.phone),
          ),
          Location(
            point: Point(
              id: 'Egorka_SBOR_FBS',
              code: '',
            ),
            contact: Contact(name: event.name, phoneMobile: event.phone),
          )
        ],
        ancillaries: event.ancillaries,
        cargos: event.cargos,
      ),
    );
    emit(MarketPlacesSuccessState(result));
  }

  void _calculateOrderMarketplace(
      CalcOrderMarketplace event, Emitter<MarketPlaceState> emit) async {
    if (event.loadingAnimation) emit(CalcLoading());
    var result = await Repository().getCoastMarketPlace(
      CoastMarketPlace(
        iD: event.id,
        type: "Truck",
        group: event.group,
        locations: [
          Location(
            date: event.time != null
                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(event.time!)
                : null,
            point: Point(
              code:
                  '${event.suggestion!.point!.latitude},${event.suggestion!.point!.longitude}',
              entrance: event.entrance,
              floor: event.floor,
              room: event.room,
            ),
            contact: Contact(name: event.name, phoneMobile: event.phone),
          ),
          Location(
            point: Point(code: '${event.points!.code}'),
            contact: Contact(name: event.name, phoneMobile: event.phone),
          )
        ],
        ancillaries: event.ancillaries,
        cargos: event.cargos,
      ),
    );
    emit(MarketPlacesSuccessState(result));
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
      emit(MarketPlacesState(marketPlaces));
    }
  }

  void _createForm(CreateForm event, Emitter<MarketPlaceState> emit) async {
    emit(CreateFormState());
    CreateFormModel? result = await Repository().createForm(event.id);

    if (result != null) {
      emit(CreateFormSuccess(result));
    } else {
      emit(CreateFormFail());
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

  void _updateState(MarketUpdateState event, Emitter<MarketPlaceState> emit) =>
      emit(UpdateState());
}
