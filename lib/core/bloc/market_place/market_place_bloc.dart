import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_base.dart' as base;
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:intl/intl.dart';
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
    on<CreateForm>(_createForm);
  }

  void _calculateOrder(CalcOrder event, Emitter<MarketPlaceState> emit) async {
    emit(CalcLoading());
    var result = await Repository().getCoastBase(
      base.CoastBase(
        locations: [
          base.Locations(
            date: event.time != null
                ? DateFormat('YYYY.MM.DD HH:MM:SS').format(event.time!)
                : null,
            point: base.Point(
              code: event.suggestion!.iD,
              entrance: event.entrance,
              floor: event.floor,
              room: event.room,
            ),
            contact: base.Contact(
                name: 'тест имя 1',
                phoneMobile: 'тест телефон 1',
                phoneOffice: 'тест телефон 1',
                phoneOfficeAdd: 'тест телефон 1'),
          ),
          base.Locations(
            point: base.Point(
              code: event.points!.code,
            ),
            contact: base.Contact(
                name: 'тест имя 2',
                phoneMobile: 'тест телефон 2',
                phoneOffice: 'тест телефон 2',
                phoneOfficeAdd: 'тест телефон 2'),
          )
        ],
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
      emit(MarketPlacesSuccessState(null));
    }
  }

  void _createForm(CreateForm event, Emitter<MarketPlaceState> emit) async {
    emit(CreateFormState());
    CreateFormModel? result = await Repository().createForm(event.id);

    if (result != null) {
      emit(CreateFormSuccess());
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
}
