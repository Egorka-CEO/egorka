import 'dart:math';

import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/ancillaries.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/contact.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/poinDetails.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
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
    on<NewOrderUpdateState>(_updateState);
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

    CoastResponse? coasts;
    List<Location> locations = [];

    for (var element in event.start) {
      locations.add(
        Location(
          type: 'Pickup',
          point: Point(
            code:
                '${element.suggestions.point!.latitude},${element.suggestions.point!.longitude}',
            entrance: element.details?.entrance,
            floor: element.details?.floor,
            room: element.details?.room,
          ),
          contact: Contact(
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
        Location(
          type: 'Drop',
          point: Point(
            code:
                '${element.suggestions.point!.latitude},${element.suggestions.point!.longitude}',
            entrance: element.details?.entrance,
            floor: element.details?.floor,
            room: element.details?.room,
          ),
          contact: Contact(
            name: element.details?.name,
            phoneMobile: element.details?.phone,
            phoneOffice: element.details?.phone,
            phoneOfficeAdd: element.details?.phone,
          ),
        ),
      );
    }

    final res = await Repository().getCoastAdvanced(
      CoastAdvanced(
        type: event.typeCoast,
        locations: locations,
        ancillaries: event.ancillaries,
        description: event.description,
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
      emit(CreateFormSuccess(result));
    } else {
      emit(CreateFormFail());
    }
  }

  void _updateState(NewOrderUpdateState event, Emitter<NewOrderState> emit) =>
      emit(UpdateState());
}
