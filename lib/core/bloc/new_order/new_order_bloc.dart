import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/poinDetails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:egorka/model/coast_advanced.dart' as cstAdvanced;
import 'package:egorka/model/response_coast_base.dart' as respCoast;
part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderPageBloc extends Bloc<NewOrderEvent, NewOrderState> {
  late GeoData data;
  NewOrderPageBloc() : super(NewOrderStated()) {
    on<NewOrder>(_searchAddress);
    on<NewOrderOpenBtmSheet>(_openBtmSheet);
    on<NewOrderStatedCloseBtmSheet>(_closeBtmSheet);
    on<NewOrderCloseBtmSheetEvent>(_closeBtmSheetWithoutSearch);
    on<CalculateCoastEvent>(_calcCoast);
    on<CreateForm>(_createForm);
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

  void _calcCoast(
      CalculateCoastEvent event, Emitter<NewOrderState> emit) async {
    emit(CalcLoading());

    respCoast.CoastResponse? coasts;
    List<cstAdvanced.Locations> locations = [];

    for (var element in event.start) {
      locations.add(
        cstAdvanced.Locations(
          type: 'Pickup',
          point: cstAdvanced.Point(
            code: element.suggestions.iD,
            entrance: element.details?.entrance,
            floor: element.details?.floor,
            room: element.details?.room,
          ),
          contact: cstAdvanced.Contact(
            name: element.details?.name,
            phoneMobile: element.details?.phone,
            phoneOffice: element.details?.phone,
            phoneOfficeAdd: element.details?.phone,
          ),
        ),
      );
    }

    for (var element in event.end) {
      locations.add(
        cstAdvanced.Locations(
          type: 'Drop',
          point: cstAdvanced.Point(
            code: element.suggestions.iD,
            entrance: element.details?.entrance,
            floor: element.details?.floor,
            room: element.details?.room,
          ),
          contact: cstAdvanced.Contact(
            name: element.details?.name,
            phoneMobile: element.details?.phone,
            phoneOffice: element.details?.phone,
            phoneOfficeAdd: element.details?.phone,
          ),
        ),
      );
    }

    final res = await Repository().getCoastAdvanced(
      cstAdvanced.CoastAdvanced(
        type: event.typeCoast,
        locations: locations,
      ),
    );

    if (res != null) {
      coasts = res;
    }

    emit(CalcSuccess(coasts));
  }

  void _createForm(CreateForm event, Emitter<NewOrderState> emit) async {
    emit(CreateFormState());
    CreateFormModel? result = await Repository().createForm(event.id);

    if (result != null) {
      emit(CreateFormSuccess());
    } else {
      emit(CreateFormFail());
    }
  }
}
