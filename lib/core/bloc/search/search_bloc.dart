import 'dart:html';
import 'dart:math';

import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  late GeoData data;
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>((event, emit) => _searchAddress(event, emit));
    on<SearchAddressClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>((event, emit) => _changeMapPosition(event, emit));
  }

  void _searchAddress(
      SearchAddress event, Emitter<SearchAddressState> emit) async {
    emit(SearchAddressLoading());
    if (event.value.length < 2) {
      emit(SearchAddressStated());
    } else {
      var result = await Repository().getAddress(event.value);

      if (result != null) {
        emit(SearchAddressSuccess(result));
      } else {
        emit(SearchAddressFailed());
      }
    }
  }

  void _changeMapPosition(
      ChangeMapPosition event, Emitter<SearchAddressState> emit) async {
    data = await Geocoder2.getDataFromCoordinates(
        latitude: event.coordinates.latitude.toDouble(),
        longitude: event.coordinates.longitude.toDouble(),
        googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

    emit(ChangeAddressSuccess(data));
  }

  void _clearAddress() => emit(SearchAddressStated());
}
