import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart' as cstAdvanced;
import 'package:egorka/model/coast_base.dart' as cstBase;
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/response_coast_base.dart' as respCoast;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  GeoData? data;
  bool isPolilyne = false;
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>((event, emit) => _searchAddress(event, emit));
    on<SearchAddressClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>((event, emit) => _changeMapPosition(event, emit));
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<DeletePolilyneEvent>((event, emit) => _deletePolyline(event, emit));
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<SearchAddressPolilyne>((event, emit) => _getPoliline(event, emit));
  }

  void _deletePolyline(
      DeletePolilyneEvent event, Emitter<SearchAddressState> emit) {
    isPolilyne = false;
    emit(DeletePolilyneState());
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
    if (!isPolilyne) {
      data = await Geocoder2.getDataFromCoordinates(
          latitude: event.coordinates.latitude.toDouble(),
          longitude: event.coordinates.longitude.toDouble(),
          language: 'RU',
          googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

      emit(ChangeAddressSuccess(data));
    }
  }

  void _getPoliline(
      SearchAddressPolilyne event, Emitter<SearchAddressState> emit) async {
    isPolilyne = true;

    final locationFrom = await Geocoder2.getDataFromAddress(
        address: event.suggestionsStart.name, googleMapApiKey: apiKey);
    final locationTo = await Geocoder2.getDataFromAddress(
        address: event.suggestionsEnd.name, googleMapApiKey: apiKey);

    final directions = await DirectionsRepository(dio: null).getDirections(
        origin: LatLng(locationFrom.latitude, locationFrom.longitude),
        destination: LatLng(locationTo.latitude, locationTo.longitude));
    if (directions != null) {
      final fromIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/from.png', 90));
      final toIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/to.png', 90));

      String? iD = await MySecureStorage().getID();
      print('response id ${iD}');
      print(
          'response id ${event.suggestionsStart.iD} ${event.suggestionsEnd.iD}}');

      List<String> type = ['Walk', 'Car'];
      List<respCoast.CoastResponse> coasts = [];

      for (var element in type) {
        final res = await Repository().getCoastBase(
          cstBase.CoastBase(
            iD: null,
            type: element,
            locations: [
              cstBase.Locations(
                date: '2022-12-22 20:10:00',
                point: cstBase.Point(
                  code: event.suggestionsStart.iD,
                  entrance: null,
                  floor: null,
                  room: null,
                ),
              ),
              cstBase.Locations(
                date: null,
                point: cstBase.Point(
                  code: event.suggestionsStart.iD,
                  entrance: null,
                  floor: null,
                  room: null,
                ),
              ),
            ],
            ancillaries: null,
          ),
        );
        if (res != null) coasts.add(res);
      }

      emit(SearchAddressRoutePolilyne(directions, {
        Marker(
          icon: fromIcon,
          markerId: const MarkerId('start'),
          position: LatLng(directions.polylinePoints.first.latitude,
              directions.polylinePoints.first.longitude),
        ),
        Marker(
          icon: toIcon,
          markerId: const MarkerId('finish'),
          position: LatLng(directions.polylinePoints.last.latitude,
              directions.polylinePoints.last.longitude),
        ),
      }));
    } else {
      isPolilyne = false;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _clearAddress() => emit(SearchAddressStated());
}
