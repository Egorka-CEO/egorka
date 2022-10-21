import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/directions.dart';
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
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<SearchAddressPolilyne>((event, emit) => _getPoliline(event, emit));
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
        language: 'RU',
        googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

    emit(ChangeAddressSuccess(data));
  }

  void _getPoliline(
      SearchAddressPolilyne event, Emitter<SearchAddressState> emit) async {
    final location = await Geocoder2.getDataFromAddress(
        address: event.to, googleMapApiKey: apiKey);
    final directions = await DirectionsRepository(dio: null).getDirections(
        origin: LatLng(data.latitude, data.longitude),
        destination: LatLng(location.latitude, location.longitude));
    if (directions != null) {
      emit(SearchAddressRoutePolilyne(directions, {
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(directions.polylinePoints.first.latitude,
              directions.polylinePoints.first.longitude),
        ),
        Marker(
          markerId: const MarkerId('finish'),
          position: LatLng(directions.polylinePoints.last.latitude,
              directions.polylinePoints.last.longitude),
        ),
      }));
    }
  }

  void _clearAddress() => emit(SearchAddressStated());
}
